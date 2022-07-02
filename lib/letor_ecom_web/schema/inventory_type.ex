defmodule LetorEcomWeb.Schema.Types.InventoryType do
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
  alias LetorEcom.Centres.Inventory
  alias LetorEcomWeb.Schema.Middleware

  object :inventory_type do
    field(:id, :id)
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :brand_name, :string
    field :buy_price, :decimal
    field :description, :string
    field :expired, :boolean
    field :expiry_date, :date
    field :bulk_quantity, :integer
    field :bulk_quantity_uom, :string
    field :sales_unit_quantity_uom, :string
    field :sales_unit_quantity, :integer
    field :max_bulk_quantity, :integer
    field :name, :string

    field(:qr_code_url, :string,
      resolve: fn query, _, _ ->
        Catalogue.get_inventory_qr_code_url(query)
      end
    )

    field :quality_assurance_status, :string
    field :unit_sales_price, :decimal
    field :bulk_sales_price, :decimal
    field :size, :integer
    field :status, :string
    field :inventory_code, :string
    field :re_order_level, :integer
    field :re_ordering_required, :boolean
    field :shelf_replenishment_levels, :integer
    field :shelf_replenishment_required, :boolean

    field :inventory_location, :inventory_location_type,
      resolve: dataloader(Centres, :inventory_location, args: %{deleted: false})

    field :item_image, :item_image_type,
      resolve: dataloader(Catalogue, :item_image, args: %{deleted: false})

    # field :sku, :sku_type, resolve: dataloader(Catalogue, :sku, args: %{deleted: false})

    # field(:inventory_change_history, list_of(:inventory_change_history_type),
    #  resolve: dataloader(Centres, :inventory_change_history, args: %{deleted: false})
    # )

    # field(:inventory_metrics, list_of(:inventory_metrics),
    # resolve: dataloader(Centres, :inventory_metrics, args: %{deleted: false})
    # )

    # field(:purchase_items, list_of(:purchase_items_type),
    # resolve: dataloader(Centres, :purchase_items, args: %{deleted: false})
    # )

    # field :pickup_centre, :pickup_centres_type,
    # resolve: dataloader(Catalogue, :pickup_centre, args: %{deleted: false})

    field :error, list_of(:mutation_error)
  end

  input_object :inventory_input_type do
    field :brand_name, :string
    field :buy_price, :decimal
    field :description, :string
    field :expiry_date, :date
    field :bulk_quantity, :integer
    field :bulk_quantity_uom, :string
    field :sales_unit_quantity_uom, :string
    field :sales_unit_quantity, :integer
    field :max_bulk_quantity, :integer
    field :name, :string
    field :unit_sales_price, :decimal
    field :bulk_sales_price, :decimal
    field :size, :integer
    field :re_order_level, :integer
    field :re_ordering_required, :boolean
    field :shelf_replenishment_levels, :integer
    field :shelf_replenishment_required, :boolean
    field :inventory_location_id, :id
    field :item_image_id, :id
  end

  object :inventory_change_history_type do
    field(:id, :id)
    field(:buy_price, :decimal)
    field(:bulk_quantity, :integer)
    field(:sales_unit_quantity, :integer)
    field(:unit_sales_price, :decimal)
    field(:bulk_sales_price, :decimal)
    field(:change_type, :string)

    field :inventory, list_of(:inventory_type) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :inventory_items_filter_input_type)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(dataloader(Centres, :inventory))
    end

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
  end

  input_object :inventory_items_filter_input_type do
    @desc "filter by brand name"
    field(:brand_name, list_of(:string))
    @desc "filter by internal quantity"
    field(:sales_unit_quantity, :integer)
    @desc "filter by external quantity"
    field(:bulk_quantity, :integer)
    @desc "filter by status"
    field(:status, :string)
  end

  input_object :inventory_update_input_type do
    field(:brand_name, :string)
    field(:buy_price, :decimal)
    field(:description, :string)
    field(:expiry_date, :date)
    field(:bulk_quantity, :integer)
    field(:bulk_quantity_uom, :string)
    field(:sales_unit_quantity_uom, :string)
    field(:sales_unit_quantity, :integer)
    field(:max_bulk_quantity, :integer)
    field(:name, :string)
    field(:quality_assurance_status, :string)
    field(:unit_sales_price, :decimal)
    field(:bulk_sales_price, :decimal)
    field(:size, :integer)
    field(:status, :string)
    field(:re_order_level, :integer)
    field(:shelf_replenishment_levels, :integer)
    field(:inventory_location_id, :id)
    field(:item_subcategory_id, :id)
  end

  object :inventory_mutation do
    field :update_inventory, :inventory_type, description: "change inventory location" do
      arg(:inventory_id, non_null(:id))
      arg(:input, non_null(:inventory_update_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: params} = args, _ ->
        inventory =
          Inventory
          |> preload([
            :pickup_centre,
            :inventory_location,
            :item_image,
            :sku,
            :inventory_change_history,
            :inventory_metrics,
            :purchase_items
          ])
          |> Repo.get!(args[:inventory_id])

        case Centres.update_inventory(
               inventory,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_inventory, :inventory_type, description: "Delete inventory" do
      arg(:inventory_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "store manager"
      ])

      resolve(fn args, _ ->
        inventory =
          Inventory
          |> preload([
            :pickup_centre,
            :inventory_location,
            :item_image,
            :sku,
            :inventory_change_history,
            :inventory_metrics,
            :purchase_items
          ])
          |> Repo.get!(args[:inventory_id])

        case Centres.delete_inventory(inventory) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :inventory_query do
    field :inventory, list_of(:inventory_type), description: "Get list of inventory items" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)

      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        inventory =
          Inventory
          |> Centres.search_inventories(args[:keywords])
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, inventory}
      end)
    end

    field :inventory_by_id, :inventory_type, description: "fetch a inventory by id" do
      arg(:inventory_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        inventory = Inventory |> Repo.get!(args[:inventory_id])
        {:ok, inventory}
      end)
    end
  end
end
