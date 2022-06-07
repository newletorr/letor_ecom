defmodule LetorEcomWeb.Schema.Types.ItemsType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Catalogue, Centres, Control, Ordering, Repo}
  alias LetorEcom.Catalogue.Item
  alias LetorEcom.Centres.SalesPromotion
  alias LetorEcom.Repo
  alias LetorEcomWeb.Schema.Middleware

  object :items_type do
    field(:id, :id)
    field(:actual_price, :decimal)
    field(:availability_time, :string)
    field(:available_quantity, :integer)
    field(:barcode, :string)
    field(:brand_name, :string)
    field(:bulk, :boolean)
    field(:customization_allowed, :boolean)
    field(:description, :string)
    field(:details, :string)
    field(:expired, :boolean)
    field(:group_buying_price, :decimal)
    field(:item_code, :string)
    field(:main_price, :decimal)
    field(:name, :string)
    field(:out_of_stock, :boolean)
    field(:package_size, :string)
    field(:preparation_time, :string)
    field(:promo_price, :decimal)
    field(:qa_cleared, :boolean)
    # LetorEcom.Uploads.Type)
    field(:regional_name, :string)
    field(:size, :integer)
    field(:third_party_item, :string)
    field(:type, :string)
    field(:instore_location, :string)

    field(:qr_code_url, :string,
      resolve: fn query, _, _ ->
        Catalogue.get_qr_code_url(query)
      end
    )

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)

    field(:sku, :sku_type, resolve: dataloader(Control, :sku, args: %{deleted: false}))

    # field(:recipes, list_of(:recipe_type),
    # resolve: dataloader(Delicacies, :recipe, args: %{deleted: false})
    # )

    # field(:item_subcategories, :item_subcategory_type,
    # resolve: dataloader(Catalogue, :item_subcategory, args: %{deleted: false})
    # )

    # field(:item_images, :item_image_type,
    # resolve: dataloader(Catalogue, :item_image, args: %{deleted: false})
    # )

    # field :reviews, list_of(:reviews_type) do
    # arg(:limit, :integer, default_value: 6)
    # arg(:offset, :integer, default_value: 0)
    # resolve(dataloader(Catalogue, :reviews, args: %{deleted: false, scope: :item}))
    # end

    # field :item_tag, list_of(:item_tag_type),
    # resolve: dataloader(Catalogue, :item_tag, args: %{deleted: false})

    # field :item_taggings, list_of(:item_tagging_type),
    # resolve: dataloader(Catalogue, :item_taggings, args: %{deleted: false})

    # field(:centre_inventory_location, :centre_inventory_location_type,
    # resolve: dataloader(Centres, :centre_inventory_location, args: %{deleted: false})
    # )

    # field :cart_items, list_of(:cart_items_type) do
    # arg(:limit, :integer, default_value: 30)
    # arg(:offset, :integer, default_value: 0)
    # resolve(dataloader(Ordering, :cart_items))
    # end

    field(:error, list_of(:mutation_error))
  end

  object :sku_type do
    field(:code, :string)
    field(:name, :string)

    # field(:pickup_centre, :pickup_centre_type,
    # resolve: dataloader(Centres, :pickup_centre, args: %{deleted: false})
    # )

    field :items, list_of(:items_type) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, :sort_order, default_value: :asc)
      resolve(dataloader(Catalogue, :item))
    end

    # has_many(:inventories, Inventory)
  end

  input_object :items_input_type do
    field(:barcode, :string)
    field(:item_tag_id, :id)
    field(:details, :string)
    field(:item_subcategory_id, non_null(:id))
    field(:type, non_null(:string))
    field(:brand_name, :string)
    field(:package_uom, :string)
    field(:item_image_id, non_null(:id))
    field(:pickup_centre_id, non_null(:id))
    field(:inventory_location_id, non_null(:id))
    field(:description, non_null(:string))
    field(:max_bulk_quantity, non_null(:integer))
    field(:name, non_null(:string))
    field(:re_order_level, :integer)
    field(:sales_unit_quantity, :integer)
    field(:bulk_quantity, :integer)
    field(:sales_unit_quantity_uom, :string)
    field(:bulk_quantity_uom, :string)
    field(:buy_price, non_null(:decimal))
    field(:unit_sales_price, non_null(:decimal))
    field(:bulk_sales_price, non_null(:decimal))
    field(:status, :string)
    field(:expiry_date, :date)
  end

  input_object :food_vendor_input_type do
    field(:type, non_null(:string))
    field(:name, non_null(:string))
    field(:details, non_null(:string))
    field(:main_price, non_null(:decimal))
    field(:package_size, :string)
    field(:description, :string)
    field(:food_vendor_id, non_null(:id))
  end

  input_object :add_promo_type do
    field(:sales_promotion_id, non_null(:id))
  end

  input_object :add_promo_to_items_type do
    field(:sales_promotion_id, non_null(:id))
    field(:pickup_centre_id, non_null(:id))
  end

  input_object :remove_promo_from_items_input_type do
    field(:pickup_centre_id, non_null(:id))
  end

  input_object :all_items_filter_input_type do
    @desc "brand name"
    field(:brand_name, list_of(:string))
    @desc "get items by tag name"
    field(:tag, list_of(:string))
  end

  input_object :special_cat_items_input_type do
    field(:item_id, non_null(:id))
    field(:pickup_centre_id, non_null(:id))
  end

  object :items_mutation do
    field :create_items, :items_type, description: "Create items" do
      arg(:input, non_null(:items_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn %{input: input}, _ ->
        case Catalogue.create_sku_inventory_and_item(input) do
          {:error, :sku, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:error, :inventory, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:error, :item, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:error, :item_tagging, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:ok, %{item: item}} ->
            {:ok, item}
        end
      end)
    end

    field :create_food_vendor_items, :items_type, description: "Create vendor items" do
      arg(:input, non_null(:food_vendor_input_type))

      middleware(Middleware.Authorize, [
        "senior developer",
        "junior developer",
        "restaurant"
      ])

      resolve(fn %{input: input}, _ ->
        case Catalogue.create_vendor_food_item(input) do
          {:error, :sku, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:error, :item_image, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:error, :item, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:ok, %{item: item}} ->
            {:ok, item}
        end
      end)
    end

    field :update_items, :items_type, description: "Update items" do
      arg(:items_id, non_null(:id))
      arg(:input, non_null(:items_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn %{input: params} = args, _ ->
        items =
          Item
          |> preload([
            :item_subcategory,
            :item_image,
            :reviews,
            :sku,
            :featured_items,
            :daily_deals,
            :popular_items
          ])
          |> Repo.get!(args[:items_id])

        case Catalogue.update_item(
               items,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_items, :items_type, description: "Delete items" do
      arg(:items_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn args, _ ->
        items =
          Item
          |> preload([
            :item_subcategory,
            :recommend_item,
            :item_image,
            :reviews,
            :sku,
            :featured_items,
            :daily_deals,
            :popular_items,
            :brand_name
          ])
          |> Repo.get!(args[:items_id])

        case Catalogue.delete_item(items) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :add_to_featured_items, :items_type, description: "Add item to list of featured items " do
      arg(:input, non_null(:special_cat_items_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn %{input: input}, _ ->
        item =
          Item
          |> Repo.get!(input.item_id)

        case Catalogue.add_item_to_featured(item, input.pickup_centre_id) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, item} ->
            {:ok, item}
        end
      end)
    end

    field :remove_from_featured_items, :items_type,
      description: "Remove item from list of featured items " do
      arg(:item_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn args, _ ->
        item =
          Item
          |> Repo.get!(args[:item_id])

        case Catalogue.remove_item_from_featured(item) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, item} ->
            {:ok, item}
        end
      end)
    end

    field :add_to_daily_deals, :items_type, description: "Add item to list of daily deals " do
      arg(:input, non_null(:special_cat_items_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn %{input: input}, _ ->
        item =
          Item
          |> Repo.get!(input.item_id)

        case Catalogue.add_item_to_daily_deals(item, input.pickup_centre_id) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, item} ->
            {:ok, item}
        end
      end)
    end

    field :remove_from_daily_deals, :items_type,
      description: "Remove item from list of daily deals items " do
      arg(:item_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer",
        "content officer"
      ])

      resolve(fn args, _ ->
        item =
          Item
          |> Repo.get!(args[:item_id])

        case Catalogue.remove_item_from_daily_deals(item) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, item} ->
            {:ok, item}
        end
      end)
    end
  end

  object :items_query do
    field :items, list_of(:items_type), description: "Get list of items" do
      arg(:limit, :integer, default_value: 100)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(fn args, _ ->
        {:ok, Catalogue.list_all_items(args)}
      end)
    end

    field :groceries, list_of(:items_type), description: "Get list of Groceries items" do
      arg(:limit, :integer, default_value: 100)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(fn args, _ ->
        {:ok, Catalogue.list_groceries_items(args)}
      end)
    end

    field :health_and_personal_care, list_of(:items_type),
      description: "Get list of Health and personal care items" do
      arg(:limit, :integer, default_value: 100)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(fn args, _ ->
        {:ok, Catalogue.list_health_items(args)}
      end)
    end

    field :household, list_of(:items_type), description: "Get list of Household items" do
      arg(:limit, :integer, default_value: 100)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(fn args, _ ->
        {:ok, Catalogue.list_household_items(args)}
      end)
    end

    field :item_by_id, :items_type, description: "fetch an Item by id" do
      arg(:item_id, non_null(:id))

      resolve(fn args, _ ->
        item = Item |> Repo.get!(args[:item_id])
        {:ok, item}
      end)
    end

    field :item_by_name, :items_type, description: "fetch Item by name" do
      arg(:name, non_null(:string))

      resolve(fn %{name: name}, _ ->
        {:ok, item} = Catalogue.item_by_name(name)
        {:ok, item}
      end)
    end

    field :item_by_barcode, :items_type, description: "fetch Item by barcode" do
      arg(:name, non_null(:string))

      resolve(fn %{barcode: barcode}, _ ->
        {:ok, item} = Catalogue.item_by_barcode(barcode)
        {:ok, item}
      end)
    end
  end
end
