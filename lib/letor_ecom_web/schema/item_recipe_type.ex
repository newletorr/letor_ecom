defmodule LetorEcomWeb.Schema.Types.ItemRecipeType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Catalogue, Delicacies, Repo}
  alias LetorEcom.Delicacies.ItemRecipe
  alias LetorEcom.Repo
  alias LetorEcomWeb.Schema.Middleware

  object :item_recipe_type do
    field :id, :id
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :items, list_of(:items_type) do
      arg(:limit, :integer, default_value: 30)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, :sort_order, default_value: :asc)
      resolve(dataloader(Catalogue, :items))
    end

    field :recipes, :recipe_type,
      resolve: dataloader(Delicacies, :recipe, args: %{deleted: false})

    field :error, list_of(:mutation_error)
  end

  input_object :item_recipe_input_type do
    field :item_id, non_null(:id)
    field :recipe_id, non_null(:id)
  end

  object :item_recipe_mutation do
    field :create_item_recipe, :item_recipe_type, description: "Create Item recipe" do
      arg(:input, non_null(:item_recipe_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, _ ->
        case Delicacies.create_item_recipe(input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_item_recipe, :item_recipe_type, description: "Update item recipe" do
      arg(:item_recipe_id, non_null(:id))
      arg(:input, non_null(:item_recipe_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        item_recipe =
          ItemRecipe
          |> preload([:item, :recipe])
          |> Repo.get!(args[:item_recipe_id])

        case Delicacies.update_item_recipe(
               item_recipe,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_item_recipe, :item_recipe_type, description: "Delete item recipe" do
      arg(:item_recipe_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        item_recipe =
          ItemRecipe
          |> Repo.get!(args[:item_recipe_id])

        case Delicacies.delete_item_recipe(item_recipe) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :item_recipe_query do
    field :item_recipe, list_of(:item_recipe_type), description: "Get list of centre codes" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 20)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        item_recipe =
          ItemRecipe
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, item_recipe}
      end)
    end
  end
end
