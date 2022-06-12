defmodule LetorEcomWeb.Schema.Types.RecipeClassType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Delicacies, Repo}
  alias LetorEcom.Delicacies.RecipeClass
  alias LetorEcomWeb.Schema.Middleware

  object :recipe_class_type do
    field(:id, :id)
    field(:name, non_null(:string))
    field(:description, non_null(:string))
    field(:inserted_at, :datetime)
    field(:updated_at, :datetime)

    field(:recipe, :recipe_type,
      resolve: dataloader(Delicacies, :recipes, args: %{deleted: false})
    )

    field(:error, list_of(:mutation_error))
  end

  input_object :recipe_class_input_type do
    field(:name, non_null(:string))
    field(:description, non_null(:string))
  end

  object :recipe_class_mutation do
    field :create_recipe_class, :recipe_class_type, description: "Create a new recipe class" do
      arg(:input, non_null(:recipe_class_input_type))

      middleware(Middleware.Authorize, [
        "store manager",
        "data analyst",
        "store manager",
        "pos attendant"
      ])

      resolve(fn %{input: params}, %{context: %{current_user: current_user}} ->
        pickup_centre = Centres.get_users_pickup_centre(current_user)

        case Delicacies.create_recipe_class(Map.put(params, :pickup_centre_id, pickup_centre.id)) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, recipe_class} ->
            {:ok, recipe_class}
        end
      end)
    end

    field :update_recipe_class, :recipe_class_type, description: "Update a recipe class" do
      arg(:recipe_class_id, non_null(:id))
      arg(:input, non_null(:recipe_class_input_type))

      middleware(Middleware.Authorize, [
        "store manager",
        "data analyst",
        "store manager",
        "pos attendant"
      ])

      resolve(fn %{input: params} = args, _ ->
        recipe_class =
          RecipeClass
          |> Repo.get!(args[:recipe_class_id])

        case Delicacies.update_recipe_class(
               recipe_class,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_recipe_class, :recipe_class_type, description: "Delete recipe class" do
      arg(:recipe_class_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "store manager",
        "data analyst",
        "store manager",
        "pos attendant"
      ])

      resolve(fn args, _ ->
        recipe_class =
          RecipeClass
          |> Repo.get!(args[:recipe_class_id])

        case Delicacies.delete_recipe_class(recipe_class) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :recipe_class_query do
    field :recipe_class, list_of(:recipe_class_type), description: "Get list of recipe class" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        recipe_class =
          RecipeClass
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, recipe_class}
      end)
    end

    field :recipe_class_by_id, :recipe_class_type, description: "fetch a recipe class by id" do
      arg(:recipe_class_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        recipe_class = RecipeClass |> Repo.get!(args[:recipe_class_id])
        {:ok, recipe_class}
      end)
    end
  end
end
