defmodule LetorEcomWeb.Schema.Types.ItemImageType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Catalogue, Control, Repo}
  alias LetorEcom.Catalogue.ItemImage
  alias LetorEcomWeb.Schema.Middleware

  object :item_image_type do
    field :id, :id

    field :item_image1, :string,
      resolve: fn query, _, _ ->
        Catalogue.get_item_image1(query)
      end

    field :item_image2, :string,
      resolve: fn query, _, _ ->
        Catalogue.get_item_image1(query)
      end

    field :item_image3, :string,
      resolve: fn query, _, _ ->
        Catalogue.get_item_image1(query)
      end

    field :item_image4, :string,
      resolve: fn query, _, _ ->
        Catalogue.get_item_image1(query)
      end

    field(:item_name, :string)
    field(:video_url, :string)
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

    # belongs_to(:ecommerce_control, EcommerceControl)
    # has_many(:inventories, Inventory)
  end

  input_object :item_image_input_type do
    field :item_image1, non_null(:string)
    field :item_image2, non_null(:string)
    field :item_image3, non_null(:string)
    field :item_image4, non_null(:string)
    field(:item_name, non_null(:string))
    field(:video_url, :string)
    field(:ecommerce_control_id, non_null(:id))
  end

  object :item_image_mutation do
    field :create_item_image, :item_image_type, description: "Add item images" do
      arg(:input, non_null(:item_image_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager",
        "content creator"
      ])

      resolve(fn %{input: input}, _ ->
        case Catalogue.create_item_image(input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          {:ok, item_image} ->
            {:ok, item_image}
        end
      end)
    end

    field :update_item_image, :item_image_type, description: "Update an item image" do
      arg(:item_image_id, non_null(:id))
      arg(:input, non_null(:item_image_input_type))

      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "pos officer",
        "store manager"
      ])

      resolve(fn %{input: params} = args, _ ->
        item_image =
          ItemImage
          |> preload([:items, :inventories])
          |> Repo.get!(args[:item_image_id])

        case Catalogue.update_item_category(
               item_image,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :item_image_query do
    field :item_image, list_of(:item_image_type), description: "Get list of item images" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      #middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        item_image =
          ItemImage
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, item_image}
      end)
    end
  end
end
