defmodule LetorEcomWeb.Schema.Types.PickupCentreType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, Catalogue, Centres, Delicacies, Repo}
  alias LetorEcom.Centres.PickupCentre
  alias LetorEcomWeb.Schema.Middleware

  object :pickup_centre_type do
    field(:id, :id)
    field(:address, :string)
    field(:area, :string)
    field(:city, :string)
    field(:country, :string)
    field(:location_coordinates, :centre_coordinates_type)
    field(:name, :string)
    field(:state, :string)
    field(:centre_code, :string)

    # field(:ecommerce_control, :ecommerce_control_type,
    # resolve: dataloader(Control, :ecommerce_control, args: %{deleted: false})
    # )

    field(:item_categories, list_of(:item_category_type),
      resolve: dataloader(Catalogue, :item_categories, args: %{deleted: false})
    )

    # field(:sku, list_of(:sku_type), resolve: dataloader(Catalogue, :sku, args: %{deleted: false}))

    # field(:driver, list_of(:drivers_type),
    # resolve: dataloader(HumanResource, :driver, args: %{deleted: false})
    # )

    field(:inventories, list_of(:inventory_type),
      resolve: dataloader(Centres, :inventories, args: %{deleted: false})
    )

    field(:inventory_location, list_of(:inventory_location_type),
      resolve: dataloader(Centres, :inventory_location, args: %{deleted: false})
    )

    field(:daily_deals, list_of(:daily_deals_type),
      resolve: dataloader(Centres, :daily_deals, args: %{deleted: false})
    )

    field(:featured_item, list_of(:featured_item_type),
      resolve: dataloader(Centres, :featured_item, args: %{deleted: false})
    )

    # field(:pick_ups, list_of(:pick_up_type),
    # resolve: dataloader(CustomerPurchases, :pick_ups, args: %{deleted: false})
    # )

    field(:recipe_classes, list_of(:recipe_class_type),
      resolve: dataloader(Delicacies, args: %{deleted: false})
    )

    # field(:locations, list_of(:location_type),
    # resolve: dataloader(Control, :locations, args: %{deleted: false})
    # )

    # field(:order_dispatches, list_of(:order_dispatch_type),
    # resolve: dataloader(CustomerPurchases, :order_dispatches, args: %{deleted: false})
    # )

    # field(:staff_postings, list_of(:staff_postings_type),
    #  resolve: dataloader(HumanResource, :staff_postings, args: %{deleted: false})
    # )

    field :purchases, list_of(:purchase_type) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      resolve(dataloader(Centres, :purchases, args: %{deleted: false, scope: :pickup_centre}))
    end

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)

    field(:error, list_of(:mutation_error))
  end

  object :centre_coordinates_type do
    field(:coordinates, list_of(:float),
      resolve: fn query, _, _ ->
        Account.get_coordinates(query)
      end
    )

    field(:srid, :integer, default_value: 4326)
  end

  input_object :pickup_centre_input_type do
    field(:address, non_null(:string))
    field(:area, non_null(:string))
    field(:city, non_null(:string))
    field(:country, non_null(:string))
    field(:name, non_null(:string))
    field(:state, non_null(:string))
    field(:longitude, non_null(:float))
    field(:latitude, non_null(:float))
    field(:ecommerce_control_id, non_null(:id))
  end

  input_object :pickup_centre_update_input_type do
    field(:address, :string)
    field(:area, :string)
    field(:city, :string)
    field(:country, :string)
    field(:name, :string)
    field(:state, :string)
    field(:longitude, :float)
    field(:latitude, :float)
    field(:ecommerce_control_id, :id)
  end

  object :pickup_centre_mutation do
    field :create_pickup_centre, :pickup_centre_type, description: "Create a new pickup_centre" do
      arg(:input, non_null(:pickup_centre_input_type))

      middleware(Middleware.Authorize, [
        "ceo",
        "coo",
        "cto"
      ])

      resolve(fn %{input: input}, _ ->
        location_coord = %Geo.Point{
          coordinates: {input[:longitude], input[:latitude]},
          srid: 4326
        }

        case Centres.create_pickup_centre(Map.put(input, :location_coordinates, location_coord)) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_pickup_centre, :pickup_centre_type, description: "Update a pickup centre" do
      arg(:pickup_centre_id, non_null(:id))
      arg(:input, non_null(:pickup_centre_update_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: params} = args, _ ->
        location_coord = %Geo.Point{
          coordinates: {params[:longitude], params[:latitude]},
          srid: 4326
        }

        pickup_centre =
          PickupCentre
          |> Repo.preload([
            :ecommerce_control,
            :item_categories,
            :sku,
            :driver,
            :inventories,
            :inventory_location,
            :daily_deals,
            :featured_item,
            :popular_item,
            :pick_ups,
            :recipe_classes,
            :locations,
            :order_dispatches,
            :staff_postings
          ])
          |> Repo.get!(args[:pickup_centre_id])

        case Centres.update_pickup_centre(
               pickup_centre,
               Map.put(params, :location_coordinates, location_coord)
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_pickup_centre, :pickup_centre_type, description: "Delete pick up centre" do
      arg(:pickup_centre_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "ceo",
        "coo"
      ])

      resolve(fn args, _ ->
        pickup_centre =
          PickupCentre
          |> Repo.get!(args[:pickup_centre_id])

        case Centres.delete_pickup_centre(pickup_centre) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :pickup_centre_query do
    field :pickup_centre, list_of(:pickup_centre_type), description: "Get all pickup centres" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)
      # middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        pickup_centre =
          PickupCentre
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, pickup_centre}
      end)
    end

    field :pickup_centre_by_id, :pickup_centre_type, description: "fetch a Item Category by id" do
      arg(:pickup_centre_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        pickup_centre = PickupCentre |> Repo.get!(args[:pickup_centre_id])
        {:ok, pickup_centre}
      end)
    end
  end
end
