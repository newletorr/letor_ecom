defmodule LetorEcomWeb.Schema.Types.CartItemType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Catalogue, CustomerPurchases, Repo}
  alias LetorEcom.CustomerPurchases.CartItem
  alias LetorEcomWeb.Schema.Middleware

  object :cart_item_type do
    field :id, :id
    field :additional_info, :string
    field :decline_item, :boolean
    field :quantity, :integer
    field :sold, :boolean
    field :sub_total, :decimal
    field :purchase_price, :decimal

    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)

    field(:items, :items_type, resolve: dataloader(Catalogue, :item))

    field(:error, list_of(:mutation_error))
  end

  input_object :cart_item_input_type do
    field(:quantity, non_null(:integer))
    field(:additional_information, non_null(:string))
    field(:item_id, non_null(:id))
  end

  object :cart_item_mutation do
    field :add_cart_item, :cart_item_type, description: "Add items to cart" do
      arg(:input, non_null(:cart_item_input_type))
      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        case CustomerPurchases.create_cart_items(current_user, input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, cart_items} ->
            {:ok, cart_items}
        end
      end)
    end

    field :update_cart_item, :cart_item_type, description: "Update cart items" do
      arg(:cart_items_id, non_null(:id))
      arg(:input, non_null(:cart_item_input_type))
      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        cart_items =
          CartItem
          |> preload([:item, :order])
          |> Repo.get!(args[:cart_items_id])

        case CustomerPurchases.update_cart_item(
               cart_items,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_cart_item, :cart_item_type, description: "Delete centre code" do
      arg(:cart_items_id, non_null(:id))
      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        cart_items =
          CartItem
          |> preload([:item, :order])
          |> Repo.get!(args[:cart_item_id])

        case CustomerPurchases.delete_cart_item(cart_items) do
          {:error, changeset} ->
            {:error, details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :cart_item_query do
    field :cart_items, list_of(:cart_item_type), description: "Get list of centre codes" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      middleware(Middleware.Authorize, "customer")
      # "super admin",
      # "admin",
      # "dispatcher",
      # "store manager",
      # "dispatcher",
      # "first level control",
      # "second level control",
      # "third level control"
      # ])

      resolve(fn args, _ ->
        cart_items =
          CartItem
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, cart_items}
      end)
    end
  end
end
