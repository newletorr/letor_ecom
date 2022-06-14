defmodule LetorEcomWeb.Schema.Types.FeaturedItemType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.Account.User
  alias LetorEcom.{Catalogue, Centres, Repo}
  alias LetorEcom.Centres.FeaturedItem
  alias EcomHealthServiceWeb.Schema.Middleware

  object :featured_item_type do
    field(:id, :id)
    field :inserted_at, :datetime
    field :updated_at, :datetime

    field :items, list_of(:items_type) do
      arg(:limit, :integer, default_value: 20)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, :sort_order, default_value: :asc)

      resolve(dataloader(Catalogue, :items))
    end

    # field :pickup_centre, :pickup_centres_type,
    # resolve: dataloader(Catalogue, :pickup_centre, args: %{deleted: false})

    field :error, list_of(:mutation_error)
  end

  object :featured_item_mutation do
    field :create_featured_item, :featured_item_type, description: "Create new featured Item" do
      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer"
      ])

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        pickup_centre_id =
          Repo.one(
            from user in User,
              join: staff in assoc(user, :staff),
              join: staff_posting in assoc(staff, :staff_posting),
              join: pickup_centre in assoc(staff_posting, :pickup_centre),
              where: user.id == ^current_user.id,
              select: pickup_centre.id
          )

        if is_nil(pickup_centre_id) == false do
          case Centres.create_featured_item(Map.put(input, :pickup_centre_id, pickup_centre_id)) do
            {:error, changeset} ->
              {:error, transform_errors(changeset)}

            success ->
              success
          end
        else
          {:error, "Only staff posted to stores are allowed to perform this action"}
        end
      end)
    end

    field :delete_featured_item, :featured_item_type, description: "Delete a featured item" do
      arg(:featured_item_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "store manager"
      ])

      resolve(fn args, _ ->
        featured_item =
          FeaturedItem
          |> preload([:items, :pickup_centre])
          |> Repo.get!(args[:featured_item_id])

        case Centres.delete_featured_item(featured_item) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :featured_item_query do
    field :featured_item, list_of(:featured_item_type), description: "Get list of featured item" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        featured_item =
          FeaturedItem
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, featured_item}
      end)
    end
  end
end
