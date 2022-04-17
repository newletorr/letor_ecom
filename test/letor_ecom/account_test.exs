defmodule LetorEcom.AccountTest do
  use LetorEcom.DataCase

  alias LetorEcom.Account

  describe "users" do
    alias LetorEcom.Account.User

    import LetorEcom.AccountFixtures

    @invalid_attrs %{
      address: nil,
      business_name: nil,
      date_of_birth: nil,
      email: nil,
      first_name: nil,
      last_name: nil,
      phone: nil
      # password: nil,
      # password_confirmation: nil
    }

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        address: "No 23 Okuzu Street Diobu",
        business_name: "some business_name",
        date_of_birth: ~D[2022-03-23],
        email: "somename@email.com",
        first_name: "first_name",
        last_name: "last_name",
        phone: "08168891829"
        # password: "Password1@",
        # password_confirmation: "Password1@"
      }

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.address == "No 23 Okuzu Street Diobu"
      assert user.business_name == "some business_name"
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
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      random_value = Enum.random(1..100)

      update_attrs = %{
        address: "some updated address",
        business_name: "some updated business_name",
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
      assert user.business_name == "some updated business_name"
      assert user.date_of_birth == ~D[2022-03-23]
      assert user.email == "#{random_value}somename@email.com"
      assert user.first_name == "another_first_name"
      assert user.last_name == "another_last_name"
      assert user.full_name == "another_first_name" <> " " <> "another_last_name"
      assert user.phone == "08168891829"
      #  assert user.password_hash == user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end
  end

  describe "addresses" do
    alias LetorEcom.Account.Address

    import LetorEcom.AccountFixtures

    @invalid_attrs %{
      address1: nil,
      address2: nil,
      business_name: nil,
      order_instruction: nil,
      zip_code: nil,
      user_id: nil
    }

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Account.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Account.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      user = user_fixture()

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
      user = user_fixture()
      address = address_fixture()

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
      assert address.user_id == user.id
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_address(address, @invalid_attrs)
      assert address == Account.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Account.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Account.get_address!(address.id) end
    end
  end

  describe "refered_lists" do
    alias LetorEcom.Account.ReferedList

    import LetorEcom.AccountFixtures

    @invalid_attrs %{date_activated: nil, refered_person_id: nil}

    test "list_refered_lists/0 returns all refered_lists" do
      refered_list = refered_list_fixture()
      assert Account.list_refered_lists() == [refered_list]
    end

    test "get_refered_list!/1 returns the refered_list with given id" do
      refered_list = refered_list_fixture()
      assert Account.get_refered_list!(refered_list.id) == refered_list
    end

    test "create_refered_list/1 with valid data creates a refered_list" do
      valid_attrs = %{
        date_activated: ~U[2022-04-15 12:58:00Z],
        refered_person_id: "some refered_person_id"
      }

      assert {:ok, %ReferedList{} = refered_list} = Account.create_refered_list(valid_attrs)
      assert refered_list.date_activated == ~U[2022-04-15 12:58:00Z]
      assert refered_list.refered_person_id == "some refered_person_id"
    end

    test "create_refered_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_refered_list(@invalid_attrs)
    end

    test "update_refered_list/2 with valid data updates the refered_list" do
      refered_list = refered_list_fixture()

      update_attrs = %{
        date_activated: ~U[2022-04-16 12:58:00Z],
        refered_person_id: "some updated refered_person_id"
      }

      assert {:ok, %ReferedList{} = refered_list} =
               Account.update_refered_list(refered_list, update_attrs)

      assert refered_list.date_activated == ~U[2022-04-16 12:58:00Z]
      assert refered_list.refered_person_id == "some updated refered_person_id"
    end

    test "update_refered_list/2 with invalid data returns error changeset" do
      refered_list = refered_list_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_refered_list(refered_list, @invalid_attrs)

      assert refered_list == Account.get_refered_list!(refered_list.id)
    end

    test "delete_refered_list/1 deletes the refered_list" do
      refered_list = refered_list_fixture()
      assert {:ok, %ReferedList{}} = Account.delete_refered_list(refered_list)
      assert_raise Ecto.NoResultsError, fn -> Account.get_refered_list!(refered_list.id) end
    end

    test "change_refered_list/1 returns a refered_list changeset" do
      refered_list = refered_list_fixture()
      assert %Ecto.Changeset{} = Account.change_refered_list(refered_list)
    end
  end
end
