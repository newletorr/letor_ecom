defmodule LetorEcomWeb.Schema.Types.SupplierType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, AgentsAndSuppliers, Control, Repo}
  alias LetorEcom.AgentsAndSuppliers.Supplier
  alias LetorEcomWeb.Schema.Middleware

  object :supplier_type do
    field :id, :id
    field :address, :string
    field :business_name, :string
    field :city, :string
    field :contact_person, :string
    field :country, :string
    field :email, :string
    field :first_name, :string
    field :full_name, :string
    field :last_name, :string
    field :means_of_id, :string
    # LetorEcom.Uploads.Type
    field :logo, :string
    # LetorEcom.Uploads.Type
    field :image, :string
    # LetorEcom.Uploads.Type
    field :id_image, :string
    field :national_supplier, :boolean
    field :phone, :string
    field :rc_number, :string
    field :regional_supplier, :boolean
    field :state, :string
    field :status, :string
    field :type, :string
    field :verified, :boolean

    # field :ecommerce_control, :ecommerce_control_type,
    # resolve: dataloader(Control, :ecommerce_control, args: %{deleted: false})

    # field :location, :location_type,
    # resolve: dataloader(Control, :location, args: %{deleted: false})

    field :users, :user_type, resolve: dataloader(Account, :users, args: %{deleted: false})

    field :inserted_at, :datetime
    field :updated_at, :datetime

    field(:error, list_of(:mutation_error))
  end

  input_object :supplier_input_type do
    field :address, :string
    field :business_name, :string
    field :city, :string
    field :contact_person, :string
    field :country, :string
    field :email, :string
    field :first_name, :string
    field :full_name, :string
    field :last_name, :string
    field :means_of_id, :string
    field :logo, :upload
    field :image, :upload
    field :id_image, :upload
    field :national_supplier, :boolean
    field :phone, :string
    field :rc_number, :string
    field :regional_supplier, :boolean
    field :state, :string
    field :type, :string
    field(:location_id, :id)
  end

  object :supplier_mutation do
    field :update_supplier, :supplier_type, description: "Update a supplier" do
      arg(:supplier_id, non_null(:id))
      arg(:input, non_null(:supplier_input_type))

      middleware(Middleware.Authorize, "supplier")

      resolve(fn %{input: params} = args, _ ->
        supplier =
          Supplier
          |> Repo.get!(args[:supplier_id])

        case AgentsAndSuppliers.update_supplier(
               supplier,
               params
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :verify_supplier, :supplier_type, description: "Verify a supplier" do
      arg(:supplier_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "purchase officer",
        "customer"
      ])

      resolve(fn args, _ ->
        supplier =
          Supplier
          |> Repo.get!(args[:supplier_id])

        case AgentsAndSuppliers.verify_supplier(supplier) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :delete_supplier, :supplier_type, description: "Delete supplier" do
      arg(:supplier_id, non_null(:id))

      middleware(Middleware.Authorize, "supplier")

      resolve(fn args, _ ->
        supplier =
          Supplier
          |> Repo.get!(args[:supplier_id])

        case AgentsAndSuppliers.delete_supplier(supplier) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :supplier_query do
    field :supplier, list_of(:supplier_type), description: "Get list of supplier" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer)
      arg(:keywords, :string, default_value: nil)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        supplier =
          Supplier
          |> AgentsAndSuppliers.search_supplier(args[:keywords])
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, supplier}
      end)
    end

    field :supplier_by_id, :supplier_type, description: "fetch a Supplier by id" do
      arg(:supplier_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        supplier = Supplier |> Repo.get!(args[:supplier_id])
        {:ok, supplier}
      end)
    end
  end
end
