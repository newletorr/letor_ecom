defmodule LetorEcomWeb.Schema.Types.RecipeType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.Catalogue
  alias LetorEcom.{Delicacies, Repo}
  alias LetorEcom.Delicacies.Recipe
  alias LetorEcomWeb.Schema.Middleware

  object :recipe_type do
    field(:id, :id)
    field :description, :string
    field :directions, :string
    field :image1_url, :string
    field :image2_url, :string
    field :image3_url, :string
    field :meal_type, :string
    field :name, :string
    field :special, :boolean
    field :video, :string

    field :likes, :integer,
      resolve: fn query, _, _ ->
        Delicacies.get_recipe_like_count(query.id)
      end

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

    field(:recipe_class, :recipe_class_type,
      resolve: dataloader(Delicacies, :recipe_class, args: %{deleted: false})
    )
  end

  input_object :recipe_input_type do
    field :description, non_null(:string)
    field :name, non_null(:string)
    field :directions, non_null(:string)
    field :video, :string
    field :special, :boolean
    field :image1_url, non_null(:string)
    field :image2_url, :string
    field :image3_url, :string
    field :meal_type, :string
    field :recipe_class_id, non_null(:id)
  end

  object :recipe_mutation do
    field :create_recipe, :recipe_type, description: "Create a new recipe" do
      arg(:input, non_null(:recipe_input_type))

      middleware(Middleware.Authorize, [
        "super admin",
        "admin",
        "store manager",
        "content officer",
        "customer"
      ])

      resolve(fn %{input: input}, _ ->
        case Delicacies.create_recipe(input) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_recipe, :recipe_type, description: "Update a recipe" do
      arg(:recipe_id, non_null(:id))
      arg(:input, non_null(:recipe_input_type))

      middleware(Middleware.Authorize, [
        "super admin",
        "admin",
        "store manager",
        "content officer",
        "customer"
      ])

      resolve(fn %{input: params} = args, _ ->
        recipe =
          Recipe
          # |> preload([:recipe_subclass, :recipe_image])
          |> Repo.get!(args[:recipe_id])

        case Delicacies.update_recipe(
               recipe,
               params
             ) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_recipe, :recipe_type, description: "Delete a recipe" do
      arg(:recipe_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "super admin",
        "admin",
        "store manager",
        "content officer",
        "customer"
      ])

      resolve(fn args, _ ->
        recipe =
          Recipe
          |> preload(:recipe_subclass)
          |> Repo.get!(args[:recipe_id])

        case Delicacies.delete_recipe(recipe) do
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

  object :recipe_query do
    field :recipes, list_of(:recipe_type), description: "Get list of all recipes" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        recipe =
          Recipe
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, recipe}
      end)
    end

    field :special_recipes, list_of(:recipe_type), description: "Get list of special recipes" do
      arg(:limit, :integer, default_value: 5)
      arg(:keywords, :string, default_value: nil)
      arg(:order, type: :sort_order, default_value: :asc)

      resolve(fn args, _ ->
        {:ok, Delicacies.list_special_recipes(args)}
      end)
    end

    field :recipe_by_name, :recipe_type, description: "Fetch recipe by name" do
      arg(:name, non_null(:string))

      resolve(fn %{name: name}, _ ->
        {:ok, recipe} = Delicacies.recipe_by_name(name)
        {:ok, recipe}
      end)
    end

    field :recipe_by_id, :recipe_type, description: "fetch a recipe by id" do
      arg(:recipe_id, non_null(:id))

      resolve(fn args, _ ->
        recipe = Recipe |> Repo.get!(args[:recipe_id])
        {:ok, recipe}
      end)
    end
  end
end
