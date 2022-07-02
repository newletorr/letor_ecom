defmodule LetorEcomWeb.Schema.Types.PurchaseType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Centres, Repo}
  alias LetorEcom.Centres.Purchase
  alias LetorEcomWeb.Schema.Middleware

  object :purchase_type do
    field :id, :id
    field(:approval_remark, :string)
    field(:code, :string)
    field(:quality_assurance_cleared, :boolean)
    field(:status, :string)

    # field(:staff, :staff_type, resolve: dataloader(HumanResource, :staff, args: %{deleted: false}))

    # field(:pickup_centre, :pickup_centre_type,
    # resolve: dataloader(Centres, :pickup_centre, args: %{deleted: false})
    # )

    # field(:purchase_items, list_of(:purchase_items_type),
    # resolve: dataloader(Centres, :purchase_items, args: %{deleted: false})
    # )
  end

  object :purchase_items_type do
    field :item_name, :string
    field :quantity, :integer
    field :suppliers_email, :string
    field :suppliers_name, :string
    field :suppliers_phone, :string
    field :unit_of_measure, :string
    field :total, :decimal
    field :price_per_unit, :decimal

    field(:inventory, :inventory_type,
      resolve: dataloader(Centres, :inventory, args: %{deleted: false})
    )

    field(:purchase, :purchase_type,
      resolve: dataloader(Centres, :purchase, args: %{deleted: false})
    )
  end

  object :purchases_mutation do
    field :approve_purchase, :purchase_type, description: "approve a purchase" do
      arg(:purchase_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "store manager"
      ])

      resolve(fn args, _ ->
        purchase =
          Purchase
          |> Repo.get!(args[:purchase_id])

        case Centres.approve_purchase(purchase) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :purchases_query do
    field :purchases, list_of(:purchase_type), description: "Get list of purchases" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      arg(:keywords, :string, default_value: nil)

      resolve(fn args, _ ->
        purchase =
          Purchase
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, purchase}
      end)
    end

    field :purchase_by_id, :purchase_type, description: "Fetch Purchase by Id" do
      arg(:purchase_id, non_null(:id))

      resolve(fn args, _ ->
        purchase = Purchase |> Repo.get!(args[:purchase_id])
        {:ok, purchase}
      end)
    end
  end
end
