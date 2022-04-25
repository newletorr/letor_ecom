defmodule LetorEcom.AccountTest do
  use LetorEcom.DataCase
  alias LetorEcom.Account
  alias LetorEcom.Account.User
  alias LetorEcom.Repo

  describe "users" do
    alias LetorEcom.Account.User
    alias LetorEcom.Control.Location

    @invalid_attrs %{
      address: nil,
      business_name: nil,
      date_of_birth: nil,
      email: nil,
      first_name: nil,
      last_name: nil,
      phone: nil,
      location_id: nil
      # password: nil,
      # password_confirmation: nil
    }

    test "create_user/1 with valid data creates a user" do
      location = Repo.all(Location) |> List.first()

      valid_attrs = %{
        address: "No 23 Okuzu Street Diobu",
        date_of_birth: ~D[2022-03-23],
        email: "somename@email.com",
        first_name: "first_name",
        last_name: "last_name",
        phone: "08168891829",
        location_id: location.id
        # password: "Password1@",
        # password_confirmation: "Password1@"
      }

      assert {:ok, %{user: user}} = Account.register_customer(valid_attrs)
      assert user.address == "No 23 Okuzu Street Diobu"
      assert user.date_of_birth == ~D[2022-03-23]
      assert user.email == "somename@email.com"
      assert user.first_name == "first_name"
      assert user.last_name == "last_name"
      assert user.full_name == "first_name" <> " " <> "last_name"
      assert user.phone == "08168891829"
      assert user.role == "customer"
      # assert user.password_hash == user.password_hash
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, :user, %Ecto.Changeset{}, _} = Account.register_customer(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user = insert!(:user, location: location)

      random_value = Enum.random(1..100)

      update_attrs = %{
        address: "some updated address",
        date_of_birth: ~D[2022-03-23],
        email: "#{random_value}somename@email.com",
        first_name: "another_first_name",
        last_name: "another_last_name",
        phone: "08168891829"
        # password: "Password1@",
        # password_confirmation: "Password1@"
      }

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.address == "some updated address"
      assert user.date_of_birth == ~D[2022-03-23]
      assert user.email == "#{random_value}somename@email.com"
      assert user.first_name == "another_first_name"
      assert user.last_name == "another_last_name"
      assert user.full_name == "another_first_name" <> " " <> "another_last_name"
      assert user.phone == "08168891829"
      #  assert user.password_hash == user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user = build(:user, location: location)
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = Repo.all(User) |> List.first()
      assert {:ok, %User{}} = Account.delete_user(user)
    end
  end

  describe "addresses" do
    alias LetorEcom.Account.Address

    @invalid_attrs %{
      address1: nil,
      address2: nil,
      business_name: nil,
      order_instruction: nil,
      zip_code: nil,
      user_id: nil
    }

    test "create_address/1 with valid data creates a address" do
      user = Repo.all(User) |> List.first()

      valid_attrs = %{
        address1: "some address1",
        address2: "some address2",
        business_name: "some business_name",
        order_instruction: "some order_instruction",
        zip_code: "some zip_code",
        user_id: user.id
      }

      assert {:ok, %Address{} = address} = Account.create_address(valid_attrs)
      assert address.address1 == "some address1"
      assert address.address2 == "some address2"
      assert address.business_name == "some business_name"
      assert address.order_instruction == "some order_instruction"
      assert address.zip_code == "some zip_code"
      assert address.user_id == user.id
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      user = Repo.all(User) |> List.first()
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user1 = build(:user, location: location)
      address = insert!(:address, user: user1)

      update_attrs = %{
        address1: "some updated address1",
        address2: "some updated address2",
        business_name: "some updated business_name",
        order_instruction: "some updated order_instruction",
        zip_code: "some updated zip_code",
        user_id: user.id
      }

      assert {:ok, %Address{} = address} = Account.update_address(address, update_attrs)
      assert address.address1 == "some updated address1"
      assert address.address2 == "some updated address2"
      assert address.business_name == "some updated business_name"
      assert address.order_instruction == "some updated order_instruction"
      assert address.zip_code == "some updated zip_code"
    end

    test "update_address/2 with invalid data returns error changeset" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user = build(:user, location: location)
      address = insert!(:address, user: user)
      assert {:error, %Ecto.Changeset{}} = Account.update_address(address, @invalid_attrs)
    end

    test "delete_address/1 deletes the address" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user = build(:user, location: location)
      address = insert!(:address, user: user)
      assert {:ok, %Address{}} = Account.delete_address(address)
    end
  end

  describe "refered_lists" do
    alias LetorEcom.Account.ReferedList

    @invalid_attrs %{date_activated: nil, refered_person_id: nil}

    test "create_refered_list/1 with valid data creates a refered_list" do
      user = Repo.all(User) |> List.first()

      valid_attrs = %{
        date_activated: ~U[2022-04-15 12:58:00Z],
        refered_person_id: "some refered_person_id",
        user_id: user.id
      }

      assert {:ok, %ReferedList{} = refered_list} = Account.create_refered_list(valid_attrs)
      assert refered_list.date_activated == ~U[2022-04-15 12:58:00Z]
      assert refered_list.refered_person_id == "some refered_person_id"
    end

    test "create_refered_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_refered_list(@invalid_attrs)
    end

    test "update_refered_list/2 with valid data updates the refered_list" do
      user = Repo.all(User) |> List.first()
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user1 = insert!(:user, location: location)
      refered_list = insert!(:refered_list, user: user1)

      update_attrs = %{
        date_activated: ~U[2022-04-16 12:58:00Z],
        refered_person_id: "some updated refered_person_id",
        user_id: user.id
      }

      assert {:ok, %ReferedList{} = refered_list} =
               Account.update_refered_list(refered_list, update_attrs)

      assert refered_list.date_activated == ~U[2022-04-16 12:58:00Z]
      assert refered_list.refered_person_id == "some updated refered_person_id"
    end

    test "update_refered_list/2 with invalid data returns error changeset" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user = build(:user, location: location)
      refered_list = insert!(:refered_list, user: user)

      assert {:error, %Ecto.Changeset{}} =
               Account.update_refered_list(refered_list, @invalid_attrs)
    end

    test "delete_refered_list/1 deletes the refered_list" do
      ecommerce_control = build(:ecommerce_control)
      pickup_centre = insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      location = insert!(:location, pickup_centre: pickup_centre)
      user = build(:user, location: location)
      refered_list = insert!(:refered_list, user: user)
      assert {:ok, %ReferedList{}} = Account.delete_refered_list(refered_list)
    end
  end
end
