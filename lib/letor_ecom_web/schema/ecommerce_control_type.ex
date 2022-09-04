defmodule LetorEcomWeb.Schema.Types.EcommerceControlType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  # Centres,
  alias LetorEcom.{Control}
  alias LetorEcom.Control.EcommerceControl
  alias LetorEcom.Repo
  alias LetorEcomWeb.Schema.Middleware

  object :ecommerce_control_type do
    field :id, :id
    field :country, :string
    field :name, :string
    field :region, :string
    # field :centre_code, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime

    # field(:pickup_centre, list_of(:pickup_centres_type),
    # resolve: dataloader(Centres, :pickup_centres, args: %{deleted: false})
    # )

    # field(:staff_posting, list_of(:staff_posting_type),
    # resolve: dataloader(HumanResource, :staff_posting, args: %{deleted: false})
    # )

    # field(:delivery_charges, list_of(:delivery_charge_type),
    # resolve: dataloader(CustomerPurchases, :delivery_charges, args: %{deleted: false})
    # )

    # field(:referal_discounts, list_of(:referal_discount_type),
    # resolve: dataloader(CustomerPurchases, :referal_discounts, args: %{deleted: false})
    # )

    field(:item_image, list_of(:item_image_type),
      resolve: dataloader(Catalogue, :item_image, args: %{deleted: false})
    )

    # field(:agents, list_of(:agent_type),
    # resolve: dataloader(AgentsAndSuppliers, :agents, args: %{deleted: false})
    # )

    field(:error, list_of(:mutation_error))
  end

  input_object :ecommerce_control_input_type do
    field :country, non_null(:string)
    field :name, non_null(:string)
    field :region, non_null(:string)
    # field :centre_code, non_null(:string)
  end

  object :ecommerce_control_mutation do
    field :create_ecommerce_control, :ecommerce_control_type,
      description: "Create a new ecommerce control centre" do
      arg(:input, non_null(:ecommerce_control_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, _ ->
        case Control.create_ecommerce_control(input) do
          {:error, changeset} ->
            {:error,
             message: "Something went wrong, please try again",
             details: transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_ecommerce_control, :ecommerce_control_type, description: "Update centre code" do
      arg(:ecommerce_control_id, non_null(:id))
      arg(:input, non_null(:ecommerce_control_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        ecommerce_control =
          EcommerceControl
          |> preload(:ecommerce_control)
          |> preload(:pickup_centres)
          |> Repo.get!(args[:sku_id])

        case Control.update_ecommerce_control(
               ecommerce_control,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_ecommerce_control, :ecommerce_control_type, description: "Delete centre code" do
      arg(:ecommerce_control_id, non_null(:id))

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        ecommerce_control =
          EcommerceControl
          |> preload(:ecommerce_control)
          |> preload(:pickup_centres)
          |> Repo.get!(args[:ecommerce_control_id])

        case Control.delete_ecommerce_control(ecommerce_control) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :ecommerce_control_query do
    field :ecommerce_control, list_of(:ecommerce_control_type),
      description: "Get list of ecommerce control center" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 20)
      arg(:keywords, :string, default_value: nil)

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        ecommerce_control =
          EcommerceControl
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, ecommerce_control}
      end)
    end
  end
end
