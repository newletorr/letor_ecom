defmodule LetorEcomWeb.Schema.Types.AddressBookType do
  @moduledoc """
  Copyright © 2019 Letorr Nigeria Limited.
  All rights reserved.
  """
  use Absinthe.Schema.Notation
  import Ecto.Query, warn: false
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]
  import LetorEcomWeb.Schema.ChangesetErrors, only: [transform_errors: 1]
  alias LetorEcom.{Account, Repo}
  alias LetorEcom.Account.AddressBook
  alias LetorEcomWeb.Schema.Middleware

  object :address_book_type do
    field :id, :id
    field :address, :string
    field :city, :string
    field :area, :string
    field :state, :string
    field :zip_code, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime
    field :error, list_of(:mutation_error)
    field :user, :users_type, resolve: dataloader(Account, :user, args: %{deleted: false})
  end

  input_object :address_book_input_type do
    field :address, non_null(:string)
    field :city, non_null(:string)
    field :area, non_null(:string)
    field :state, non_null(:string)
    field :zip_code, :string
  end

  object :address_book_mutation do
    field :create_address_book, :address_book_type,
      description: "Create a new address book for users" do
      arg(:input, non_null(:address_book_input_type))
      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: input}, %{context: %{current_user: current_user}} ->
      
        case Account.create_address_book(Map.put(input, :user_id, current_user.id)) do
          {:error, changeset} ->
            {:error, details: transform_errors(changeset)}

          {:ok, address_book} ->
            {:ok, address_book}
        end
      end)
    end

    field :update_address_book, :address_book_type, description: "Update address book" do
      arg(:address_book_id, non_null(:id))
      arg(:input, non_null(:address_book_input_type))
      middleware(Middleware.Authorize, "customer")

      resolve(fn %{input: params} = args, _ ->
        address_book =
          AddressBook
          |> preload([
            :user
          ])
          |> Repo.get!(args[:address_book_id])

        case Account.update_address_book(
               address_book,
               params
             ) do
          {:error, changeset} ->
            {:error, details: transform_errors(changeset)}

          address_book ->
            address_book
        end
      end)
    end

    field :delete_address_book, :address_book_type, description: "Delete address book" do
      arg(:address_book_id, non_null(:id))
      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        address_book =
          AddressBook
          |> preload([
            :user
          ])
          |> Repo.get!(args[:address_book_id])

        case Account.delete_address_book(address_book) do
          {:error, changeset} ->
            {:error, details: transform_errors(changeset)}

          {:ok, address_book} ->
            {:ok, address_book}
        end
      end)
    end
  end

  object :address_book_query do
    field :address_book, list_of(:address_book_type), description: "Get list of address books" do
      arg(:offset, :integer, default_value: 0)
      arg(:limit, :integer, default_value: 10)
      middleware(Middleware.Authorize, "customer")

      resolve(fn args, _ ->
        address_book =
          AddressBook
          |> order_by(asc: :inserted_at)
          |> Repo.paginate(args[:offset], args[:limit])
          |> Repo.all()

        {:ok, address_book}
      end)
    end

    field :address_book_by_id, :address_book_type, description: "fetch address_book by Id" do
      arg(:address_book_id, non_null(:id))
      middleware(Middleware.Authorize, :any)

      resolve(fn args, _ ->
        address_book = AddressBook |> Repo.get!(args[:address_book_id])
        {:ok, address_book}
      end)
    end
  end
end
