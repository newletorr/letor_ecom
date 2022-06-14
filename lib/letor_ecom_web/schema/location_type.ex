defmodule LetorEcomWeb.Schema.Types.LocationType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  # AgentsAndSuppliers, Control, CustomerPurchases}
  alias LetorEcom.{Accounts, Control}
  alias LetorEcom.Control.Location
  alias LetorEcom.Repo
  alias LetorEcomWeb.Schema.Middleware

  object :location_type do
    field :city, :string
    field :country, :string
    field :location_area, :string
    field :location_coordinates, :loc_coordinates_type
    field :postal_code, :string
    field :state, :string

    field :inserted_at, :datetime
    field :updated_at, :datetime

    # field(:pickup_centre, non_null(:pickup_centres_type),
    # resolve: dataloader(Control, :pickup_centre, args: %{deleted: false})
    # )

    field(:users, list_of(:user_type),
      resolve: dataloader(Accounts, :users, args: %{deleted: false})
    )

    # field(:agents, list_of(:agent_type),
    # resolve: dataloader(AgentsAndSuppliers, :agents, args: %{deleted: false})
    # )

    # field(:orders, list_of(:order_type),
    # resolve: dataloader(CustomerPurchases, :orders, args: %{deleted: false})
    # )
  end

  input_object :location_input_type do
    field(:postal_code, non_null(:string))
    field(:location_area, non_null(:string))
    field(:city, non_null(:string))
    field(:state, non_null(:string))
    field(:country, non_null(:string))
    # field(:pickup_centre_id, non_null(:id))
  end

  object :loc_coordinates_type do
    field :location_coordinates, list_of(:float),
      resolve: fn query, _, _ ->
        Control.get_loc_coordinates(query)
      end

    field(:srid, :integer, default_value: 4326)
  end

  object :location_mutation do
    field :create_location, :location_type, description: "Create a new Location" do
      arg(:input, non_null(:location_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, _ ->
        case Control.create_location(input) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_location, :location_type, description: "Update location" do
      arg(:location_id, non_null(:id))
      arg(:input, non_null(:location_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        location =
          Location
          |> preload([
            :pickup_centre,
            :users,
            :agents,
            :orders
          ])
          |> Repo.get!(args[:location_id])

        case Control.update_location(
               location,
               params
             ) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_location, :location_type, description: "Delete location" do
      arg(:location_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        location =
          Location
          |> preload([
            :pickup_centre,
            :users,
            :agents,
            :orders
          ])
          |> Repo.get!(args[:location_id])

        case Control.delete_location(location) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :location_query do
    field :location, list_of(:location_type), description: "Get list of location" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        location =
          Location
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, location}
      end)
    end

    field :location_by_id, :location_type, description: "Fetch Location by Id" do
      arg(:location_id, non_null(:id))

      resolve(fn args, _ ->
        location = Location |> Repo.get!(args[:location_id])
        {:ok, location}
      end)
    end

    field :location_by_location_area, :location_type,
      description: "fetch location by location area" do
      arg(:location_area, non_null(:string))

      resolve(fn %{location_area: location_area}, _ ->
        {:ok, location} = Control.location_by_location_area(location_area)
        {:ok, location}
      end)
    end
  end
end
