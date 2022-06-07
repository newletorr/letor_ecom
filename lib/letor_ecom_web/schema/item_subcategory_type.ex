defmodule LetorEcomWeb.Schema.Types.ItemSubcategoryType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Catalogue, Centres, Repo}
  alias LetorEcom.Account.User
  alias LetorEcom.Catalogue.ItemSubcategory
  alias LetorEcomWeb.Schema.Middleware

  object :item_subcategory_type do
    field :id, :id
    field(:name, :string)
    field(:description, :string)
    field :inserted_at, :datetime
    field :updated_at, :datetime

    field(:error, list_of(:mutation_error))
  end

  input_object :item_subcategory_input_type do
    field(:name, non_null(:string))
    field(:description, non_null(:string))
  end

  object :item_subcategory_mutation do
    field :create_item_subcategory, :item_subcategory_type,
      description: "Create a new item category for items" do
      arg(:input, non_null(:item_subcategory_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        pickup_centre = Centres.get_users_pickup_centre(current_user)

        if is_nil(pickup_centre) == false do
          case Catalogue.create_item_subcategory(
                 Map.put(input, :pickup_centre_id, pickup_centre.id)
               ) do
            {:error, changeset} ->
              {:error, transform_errors(changeset)}

            success ->
              success
          end
        else
          {:error, "You are not authorized to perform this action"}
        end
      end)
    end

    field :update_item_subcategory, :item_subcategory_type, description: "Update an item category" do
      arg(:item_subcategory_id, non_null(:id))
      arg(:input, non_null(:item_subcategory_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: params} = args, _ ->
        item_subcategory =
          ItemSubcategory
          |> Repo.get!(args[:item_subcategory_id])

        case Catalogue.update_item_category(
               item_subcategory,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_item_subcategory, :item_subcategory_type, description: "Delete item subcategory" do
      arg(:item_subcategory_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "store manager",
        "data analyst",
        "store manager"
      ])

      resolve(fn args, _ ->
        item_subcategory =
          ItemSubcategory
          |> Repo.get!(args[:item_subcategory_id])

        case Catalogue.delete_item_subcategory(item_subcategory) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :item_subcategory_query do
    field :item_subcategory, list_of(:item_subcategory_type),
      description: "Get list of item subcategories" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        item_subcategory =
          ItemSubcategory
          |> Catalogue.search_item_categories(args[:keywords])
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, item_subcategory}
      end)
    end

    field :item_subcategory_by_id, :item_subcategory_type,
      description: "fetch a Item Category by id" do
      arg(:item_subcategory_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        item_subcategory = ItemSubcategory |> Repo.get!(args[:item_subcategory_id])
        {:ok, item_subcategory}
      end)
    end

    field :item_subcategory_by_name, :item_subcategory_type,
      description: "fetch Item Subcategory by Name" do
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)

      resolve(fn %{name: name}, _ ->
        {:ok, item_subcategory} = Catalogue.item_subcategory_by_name(name)
        {:ok, item_subcategory}
      end)
    end
  end
end
