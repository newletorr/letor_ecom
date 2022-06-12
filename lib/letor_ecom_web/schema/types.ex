defmodule LetorEcomWeb.Schema.Types do
  @moduledoc """
  Copyright © 2021 Letor Limited.
  All rights reserved.

  """
  use Absinthe.Schema.Notation
  alias LetorEcomWeb.Schema.Types

  import_types(Types.AddressBookType)
  import_types(Types.DailyDealType)
  import_types(Types.InventoryLocationType)
  import_types(Types.ItemsType)
  import_types(Types.ItemCategoryType)
  import_types(Types.ItemSubcategoryType)
  import_types(Types.ItemImageType)
  import_types(Types.InventoryType)
  import_types(Types.ItemImageType)
  import_types(Types.ItemRecipeType)
  import_types(Types.ItemSubcategoryType)
  import_types(Types.RecipeType)
  import_types(Types.RecipeClassType)
  import_types(Types.UserFavType)
  import_types(Types.ShoppingListType)
  import_types(Types.SupplierType)
  import_types(Types.UserType)
  import_types(Types.ViewedItemType)
end
