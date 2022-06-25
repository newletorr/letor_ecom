defmodule LetorEcomWeb.Schema.Types.PickupType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  # import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  # {AgentsAndSuppliers, CustomerPurchases, Centres, HumanResource, Repo}
  alias LetorEcom.Repo
  # alias LetorEcom.Accounts.User
  alias LetorEcom.CustomerPurchases
  alias LetorEcom.CustomerPurchases.PickUp
  alias LetorEcomWeb.Schema.Middleware

  object :pick_up_type do
    field :id, :id
    field :pick_up_time, :datetime
    field :picked, :boolean
    field :pickup_code, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime

    # field(:pickup_centre, :pickup_centre_type,
    # resolve: dataloader(Centres, :pickup_centre, args: %{deleted: false})
    # )

    # field(:agent, :agent_type,
    # resolve: dataloader(AgentsAndSuppliers, :agent, args: %{deleted: false})
    # )

    # field(:order, :order_type,
    # resolve: dataloader(CustomerPurchases, :order, args: %{deleted: false})
    # )

    # field(:staff, :staff_type, resolve: dataloader(HumanResource, :staff, args: %{deleted: false}))
  end

  input_object :pick_up_input_type do
    field :pick_up_time, :datetime
    field :picked, :boolean
    field :pickup_code, :string
  end

  object :pick_up_mutation do
    field :create_pick_up, :pick_up_type, description: "Schedule a pick up" do
      arg(:input, non_null(:pick_up_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        main_input = Map.put(input, :user_id, current_user.id)

        case CustomerPurchases.create_pick_up(main_input) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end

    field :update_pick_up, :pick_up_type, description: "Update pick_up" do
      arg(:pick_up_id, non_null(:id))
      arg(:input, non_null(:pick_up_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        pick_up =
          PickUp
          |> preload([
            # :pickup_centre,
            # :order,
            # :agent,
            # :staff
          ])
          |> Repo.get!(args[:pick_up_id])

        case CustomerPurchases.update_pick_up(
               pick_up,
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

    field :pick_up_confirmation, :pick_up_type, description: "Pick up confirmation" do
      arg(:pick_up_id, non_null(:id))
      arg(:input, non_null(:pick_up_input_type))

      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input} = args, %{context: %{current_user: current_user}} ->
        user = current_user |> Repo.preload(:staff)

        pick_up =
          PickUp
          |> preload([:staff, :pickup_centre, :order])
          |> Repo.get!(args[:pick_up_id])

        case CustomerPurchases.confirm_pick_up(
               pick_up,
               Map.put(input, :staff_id, user.staff_id)
             ) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :pick_up_query do
    field :pick_up, list_of(:pick_up_type), description: "Get list of all pick ups" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 20)
      arg(:keywords, :string, default_value: nil)

      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        pick_up =
          PickUp
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, pick_up}
      end)
    end
  end
end
