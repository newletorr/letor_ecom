defmodule LetorEcomWeb.Schema.Types.ItemCategoryType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Catalogue, Centres, Repo}
  alias LetorEcom.Catalogue.ItemCategory
  alias LetorEcomWeb.Schema.Middleware

  object :item_category_type do
    field :id, :id
    field(:name, :string)
    field(:description, :string)
    field :inserted_at, :datetime
    field :updated_at, :datetime

    field(:error, list_of(:mutation_error))

    field :item_subcategories, list_of(:item_subcategory_type) do
      arg(:limit, :integer)
      arg(:offset, :integer, default_value: 0)
      arg(:category_name, :string, default_value: nil)
      arg(:order, :sort_order, default_value: :asc)

      resolve(dataloader(Catalogue, :item_subcategories))
    end
  end

  input_object :item_category_input_type do
    field(:name, non_null(:string))
    field(:description, non_null(:string))
  end

  object :item_category_mutation do
    field :create_item_category, :item_category_type,
      description: "Create a new item category for items" do
      arg(:input, non_null(:item_category_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        pickup_centre = Centres.get_users_pickup_centre(current_user)

        if is_nil(pickup_centre) == false do
          case Catalogue.create_item_category(Map.put(input, :pickup_centre_id, pickup_centre.id)) do
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

    field :update_item_category, :item_category_type, description: "Update an item category" do
      arg(:item_category_id, non_null(:id))
      arg(:input, non_null(:item_category_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: params} = args, _ ->
        item_category =
          ItemCategory
          |> preload(:item_category_image)
          |> Repo.get!(args[:item_category_id])

        case Catalogue.update_item_category(
               item_category,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_item_category, :item_category_type, description: "Delete item category" do
      arg(:item_category_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "ceo",
        "cto",
        "cfo",
        "accountant",
        "senior developer",
        "junior developer",
        "data analyst",
        "store manager"
      ])

      resolve(fn args, _ ->
        item_category =
          ItemCategory
          |> Repo.get!(args[:item_category_id])

        case Catalogue.delete_item_category(item_category) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :item_category_query do
    field :item_category, list_of(:item_category_type), description: "Get list of item categories" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        item_category =
          ItemCategory
          |> Catalogue.search_item_categories(args[:keywords])
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, item_category}
      end)
    end

    field :item_category_by_id, :item_category_type, description: "fetch a Item Category by id" do
      arg(:item_category_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        item_category = ItemCategory |> Repo.get!(args[:item_category_id])
        {:ok, item_category}
      end)
    end

    field :item_category_by_name, :item_category_type, description: "fetch Item Category by Name" do
      arg(:name, non_null(:string))
      middleware(Middleware.Authorize, :any)

      resolve(fn %{name: name}, _ ->
        {:ok, item_category} = Catalogue.item_category_by_name(name)
        {:ok, item_category}
      end)
    end
  end
end
