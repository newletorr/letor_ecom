defmodule LetorEcomWeb.Schema.Types.DailyDealType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.Account.User
  alias LetorEcom.{Catalogue, Centres, Repo}
  alias LetorEcom.Centres.DailyDeals
  alias EcomHealthServiceWeb.Schema.Middleware

  object :daily_deals_type do
    field(:id, :id)
    field :inserted_at, :datetime
    field :updated_at, :datetime

    field :items, list_of(:items_type) do
      arg(:limit, :integer, default_value: 20)
      arg(:offset, :integer, default_value: 0)
      arg(:keywords, :string, default_value: nil)
      arg(:filters, :all_items_filter_input_type)
      arg(:order, :sort_order, default_value: :asc)

      resolve(dataloader(Catalogue, :items))
    end

    # field :pickup_centre, :pickup_centres_type,
    # resolve: dataloader(Catalogue, :pickup_centre, args: %{deleted: false})

    field :error, list_of(:mutation_error)
  end

  object :daily_deal_mutation do
    field :create_daily_deals, :daily_deals_type, description: "Create new daily deals" do
      middleware(Middleware.Authorize, [
        "data analyst",
        "office manager",
        "store manager",
        "pos officer"
      ])

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
        pickup_centre_id =
          Repo.one(
            from user in User,
              join: staff in assoc(user, :staff),
              join: staff_posting in assoc(staff, :staff_posting),
              join: pickup_centre in assoc(staff_posting, :pickup_centre),
              where: user.id == ^current_user.id,
              select: pickup_centre.id
          )

        if is_nil(pickup_centre_id) == false do
          case Centres.create_daily_deal(Map.put(input, :pickup_centre_id, pickup_centre_id)) do
            {:error, changeset} ->
              {:error, transform_errors(changeset)}

            success ->
              success
          end
        else
          {:error, "Only staff posted to stores are allowed to perform this action"}
        end
      end)
    end

    field :delete_daily_deals, :daily_deals_type, description: "Delete a daily deal" do
      arg(:daily_deals_id, non_null(:id))

      middleware(Middleware.Authorize, [
        "store manager"
      ])

      resolve(fn args, _ ->
        daily_deals =
          DailyDeals
          |> preload([:items, :pickup_centre])
          |> Repo.get!(args[:daily_deals_id])

        case Centres.delete_daily_deal(daily_deals) do
          {:error, changeset} ->
            {:error, transform_errors(changeset)}

          success ->
            success
        end
      end)
    end
  end

  object :daily_deal_query do
    field :daily_deals, list_of(:daily_deals_type), description: "Get list of daily deals" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        daily_deals =
          DailyDeals
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, daily_deals}
      end)
    end
  end
end
