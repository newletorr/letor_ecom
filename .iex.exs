# IEx.configure colors: [enabled: true]
# IEx.configure colors: [ eval_result: [ :cyan, :bright ] ]
IO.puts(
  IO.ANSI.red_background() <>
    IO.ANSI.white() <>
    " ❄❄❄ Welcome to Letor Ecommerce Backend IEX ❄❄❄ " <> IO.ANSI.reset()
)

Application.put_env(:elixir, :ansi_enabled, true)

IEx.configure(
  colors: [
    eval_result: [:green, :bright],
    eval_error: [[:red, :bright, "Bug Bug ..!!"]],
    eval_info: [:yellow, :bright]
  ],
  default_prompt:
    [
      # ANSI CHA, move cursor to column 1
      "\e[G",
      :white,
      "I",
      :red,
      # plain string
      "❤",
      :green,
      "%prefix",
      :white,
      "|",
      :blue,
      "%counter",
      :white,
      "|",
      :red,
      # plain string
      "▶",
      :white,
      # plain string
      "▶▶",
      # ❤ ❤-»" ,  # plain string
      :reset
    ]
    |> IO.ANSI.format()
    |> IO.chardata_to_string()
)

import Ecto.Query, warn: false
import Geo.PostGIS
alias LetorEcom.Repo

alias LetorEcom.{
  Account,
  AgentAndSuplier,
  Catalogue,
  Centres,
  Control,
  CustomerPurchases,
  HumanResource,
  Transactions
}

alias LetorEcom.Account.{Address, User, ShoppingList}
alias LetorEcom.AgentsAndSuppliers.CampusAgent
alias LetorEcom.Catalogue.{Item, ItemCategory, ItemImage, ItemSubcategory, ItemTag, Sku}

alias LetorEcom.Centres.{
  DailyDeal,
  FeaturedItem,
  Inventory,
  InventoryLocation,
  PickupCentre,
  PopularItem
}

alias LetorEcom.Control.{CoveredInstitution, EcommerceControl, Location}
alias LetorEcom.CustomerPurchases.{Order, DeliveryCharge, ReferalDiscount}
alias LetorEcom.HumanResource.{Driver, Staff, StaffPosting}
