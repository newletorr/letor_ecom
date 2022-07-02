defmodule LetorEcomWeb.Schema do
  @moduledoc """
  Absinthe graphql schema module

  """
  use Absinthe.Schema

  import_types(Absinthe.Plug.Types)
  import_types(LetorEcomWeb.Schema.Types)
  import_types(Absinthe.Type.Custom)
  alias LetorEcom.{Account, Catalogue, Centres, Delicacies, HumanResource}

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Account, Account.data())
      |> Dataloader.add_source(Catalogue, Catalogue.data())
      |> Dataloader.add_source(Centres, Centres.data())
      |> Dataloader.add_source(Delicacies, Delicacies.data())
      |> Dataloader.add_source(HumanResource, HumanResource.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  object :mutation_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end

  query do
    import_fields(:address_book_query)
    import_fields(:daily_deal_query)
    import_fields(:ecommerce_control_query)
    import_fields(:featured_item_query)
    import_fields(:inventory_location_query)
    import_fields(:items_query)
    import_fields(:item_category_query)
    import_fields(:item_subcategory_query)
    import_fields(:location_query)
    import_fields(:purchases_query)
    import_fields(:pickup_centre_query)
    import_fields(:item_image_query)
    import_fields(:inventory_query)
    import_fields(:item_recipe_query)
    import_fields(:recipe_query)
    import_fields(:recipe_class_query)
    import_fields(:shopping_list_query)
    import_fields(:supplier_query)
    import_fields(:user_query)
    import_fields(:user_fav_items_query)
    import_fields(:viewed_items_query)
  end

  mutation do
    import_fields(:address_book_mutation)
    import_fields(:daily_deal_mutation)
    import_fields(:ecommerce_control_mutation)
    import_fields(:featured_item_mutation)
    import_fields(:items_mutation)
    import_fields(:item_category_mutation)
    import_fields(:inventory_mutation)
    import_fields(:inventory_location_mutation)
    import_fields(:item_image_mutation)
    import_fields(:item_recipe_mutation)
    import_fields(:item_subcategory_mutation)
    import_fields(:location_mutation)
    import_fields(:purchases_mutation)
    import_fields(:pickup_centre_mutation)
    import_fields(:recipe_mutation)
    import_fields(:recipe_class_mutation)
    import_fields(:shopping_list_mutation)
    import_fields(:supplier_mutation)
    import_fields(:user_mutation)
    import_fields(:user_fav_items_mutation)
    import_fields(:viewed_items_mutation)
  end
end
