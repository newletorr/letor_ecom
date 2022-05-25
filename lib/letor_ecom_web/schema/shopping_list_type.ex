defmodule LetorEcomWeb.Schema.Types.ShoppingListType do
  @moduledoc """
  Copyright © 2022 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, Catalogue, Repo}
  alias LetorEcom.Account.ShoppingList
  alias LetorEcomWeb.Schema.Middleware

  object :shopping_list_type do
    field(:id, :id)
    field(:quantity, :integer)
    field(:title, :string)
    field(:item_price, :decimal)
    field(:total, :decimal)
    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)
    # field(:items, list_of(:items_type), resolve: dataloader(Catalogue))
    field(:error, list_of(:mutation_error))
  end

  input_object :shopping_list_initialization_input_type do
    field(:title, non_null(:string))
  end

  input_object :update_shopping_list_input_type do
    field :item_id, non_null(:id)
    field :quantity, non_null(:integer)
  end

  object :shopping_list_mutation do
    field :create_shopping_list, :shopping_list_type, description: "Create a new shopping list" do
      arg(:input, non_null(:shopping_list_initialization_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: context} ->
        IO.inspect(context)
        main_input = Map.put(input, :user_id, context[:current_user].id)

        case Account.create_shopping_list(main_input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_shopping_list, :shopping_list_type, description: "Update shopping list" do
      arg(:shopping_list_id, non_null(:id))
      arg(:input, non_null(:update_shopping_list_input_type))
      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, %{context: %{current_user: current_user}} ->
        actual_params = Map.put(params, :user_id, current_user.id)
        shopping_list =
          ShoppingList
          |> preload([:item, :user])
          |> Repo.get!(args[:shopping_list_id])

        case Account.update_shopping_list(
               shopping_list,
               actual_params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_shopping_list, :shopping_list_type, description: "Delete a shopping list" do
      arg(:shopping_list_id, non_null(:id))
      middleware(Middleware.Authorize, ["customer"])

      resolve(fn args, _ ->
        shopping_list =
          ShoppingList
          |> preload([:item, :user])
          |> Repo.get!(args[:shopping_list_id])

        case Account.delete_shopping_list(shopping_list) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :shopping_list_query do
    field :shopping_list, list_of(:shopping_list_type), description: "Get users shopping list" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 60)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        shopping_list =
          ShoppingList
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, shopping_list}
      end)
    end

    field :shopping_list_by_id, :shopping_list_type, description: "fetch a shopping list by id" do
      arg(:shopping_list_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        shopping_list = ShoppingList |> Repo.get!(args[:shopping_list_id])
        {:ok, shopping_list}
      end)
    end
  end
end
