defmodule LetorEcomWeb.Schema.Types.ViewedItemType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, Catalogue, Repo}
  alias LetorEcom.Account.ViewedItem
  alias LetorEcomWeb.Schema.Middleware

  object :viewed_item_type do
    field :id, :id
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :error, list_of(:mutation_error)

    field :items, list_of(:items_type) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, :sort_order, default_value: :asc)
      resolve(dataloader(Catalogue, :item))
    end

    field(:user, :user_type, resolve: dataloader(Account, :user, args: %{deleted: false}))
  end

  input_object :viewed_items_input_type do
    field(:item_id, non_null(:id))
  end

  object :viewed_items_mutation do
    field :create_viewed_item, :viewed_item_type, description: "create viewed items" do
      arg(:input, non_null(:viewed_items_input_type))
      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        case Account.create_viewed_item(Map.put(input, :user_id, current_user.id)) do
          {:error, :viewed_item, changeset, _} ->
            {:error, transform_errors(changeset)}

          {:ok, %{viewed_item: viewed_item}} ->
            {:ok, viewed_item}
        end
      end)
    end
  end

  object :viewed_items_query do
    field :viewed_item, list_of(:viewed_item_type), description: "Get list of viewed items" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        viewed_item =
          ViewedItem
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, viewed_item}
      end)
    end
  end
end
