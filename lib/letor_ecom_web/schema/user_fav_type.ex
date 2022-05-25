defmodule LetorEcomWeb.Schema.Types.UserFavType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, Catalogue, Repo}
  alias LetorEcom.Account.UserFav
  alias LetorEcomWeb.Schema.Middleware

  object :user_fav_items_type do
    field :id, :id
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :error, list_of(:mutation_error)

    #field :items, list_of(:items_type) do
     # arg(:limit, :integer, default_value: 30)
      #arg(:offset, :integer, default_value: 0)
      #arg(:keywords, :string, default_value: nil)
      #arg(:filters, :all_items_filter_input_type)
      #arg(:order, :sort_order, default_value: :asc)
      #resolve(dataloader(Catalogue, :item))
    #end

    field(:user, :users_type, resolve: dataloader(Account, :user, args: %{deleted: false}))
  end

  input_object :user_fav_items_input_type do
    field(:item_id, non_null(:id))
  end

  object :user_fav_items_mutation do
    field :create_user_fav_items, :user_fav_items_type, description: "Add a new user's dependants" do
      arg(:input, non_null(:user_fav_items_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        case Account.create_user_fav(Map.put(input, :user_id, current_user.id)) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, user_fav} ->
            {:ok, user_fav}
        end
      end)
    end

    field :remove_favourite, :user_fav_items_type, description: "Update a user dependants info" do
      arg(:user_fav_items_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        user_fav_items =
          UserFav
          |> preload([:user, :item])
          |> Repo.get!(args[:user_fav_items_id])

        case Account.delete_user_fav_item(user_fav_items) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :user_fav_items_query do
    field :user_fav_items, list_of(:user_fav_items_type), description: "Get list of centre codes" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        user_fav_items =
          UserFav
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, user_fav_items}
      end)
    end
  end
end
