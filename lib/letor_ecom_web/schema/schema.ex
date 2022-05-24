defmodule LetorEcomWeb.Schema do
  @moduledoc """
  Absinthe graphql schema module

  """
  use Absinthe.Schema

  import_types(Absinthe.Plug.Types)
  import_types(LetorEcomWeb.Schema.Types)
  import_types(Absinthe.Type.Custom)
  alias LetorEcom.Account

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Account, Account.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  object :mutation_error do
    field(:key, non_null(:string))
    field(:message, non_null(:string))
  end

  query do
    import_fields(:address_book_query)
    import_fields(:shopping_list_query)
    import_fields(:user_query)
  end

  mutation do
    import_fields(:address_book_mutation)
    import_fields(:shopping_list_mutation)
    import_fields(:user_mutation)
  end
end
