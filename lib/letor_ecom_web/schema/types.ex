defmodule LetorEcomWeb.Schema.Types do
  @moduledoc """
  Copyright © 2021 Letor Limited.
  All rights reserved.

  """
  use Absinthe.Schema.Notation
  alias LetorEcomWeb.Schema.Types

  import_types(Types.AddressBookType)
  import_types(Types.ItemsType)
  import_types(Types.ItemImageType)
  import_types(Types.UserFavType)
  import_types(Types.ShoppingListType)
  import_types(Types.SupplierType)
  import_types(Types.UserType)
  import_types(Types.ViewedItemType)
end
