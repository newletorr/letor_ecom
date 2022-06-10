defmodule LetorEcomWeb.Schema.Types.InventoryLocationType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  # import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.Repo
  alias LetorEcom.Centers.InventoryLocation
  alias LetorEcomWeb.Schema.Middleware

  object :inventory_location_type do
    field :id, :id
    field :name, non_null(:string)
    field :type, non_null(:string)
    field :inserted_at, :datetime
    field :updated_at, :datetime

    field(:error, list_of(:mutation_error))
  end

  input_object :inventory_location_input_type do
    field(:name, non_null(:string))
    field(:type, non_null(:string))
  end

  object :inventory_location_mutation do
    field :create_inventory_location, :inventory_location_type,
      description: "Create a new inventory location" do
      arg(:input, non_null(:inventory_location_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params}, _ ->
        case Centers.create_inventory_location(params) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, inventory_location} ->
            {:ok, inventory_location}
        end
      end)
    end

    field :update_inventory_location, :inventory_location_type,
      description: "Update an inventory location" do
      arg(:inventory_location_id, non_null(:id))
      arg(:input, non_null(:inventory_location_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        inventory_location =
          InventoryLocation
          |> Repo.get!(args[:inventory_location_id])

        case Centers.update_inventory_location(
               inventory_location,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_inventory_location, :inventory_location_type,
      description: "Delete item category" do
      arg(:inventory_location_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        inventory_location =
          InventoryLocation
          |> Repo.get!(args[:inventory_location_id])

        case Centers.delete_inventory_location(inventory_location) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :inventory_location_query do
    field :inventory_location, list_of(:inventory_location_type),
      description: "Get list of inventory location" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        inventory_location =
          InventoryLocation
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, inventory_location}
      end)
    end

    field :inventory_location_by_id, :inventory_location_type,
      description: "fetch a Inventory location by id" do
      arg(:inventory_location_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        inventory_location = InventoryLocation |> Repo.get!(args[:inventory_location_id])
        {:ok, inventory_location}
      end)
    end
  end
end
