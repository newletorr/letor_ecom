defmodule LetorEcom.AccountTest do
  use LetorEcom.DataCase, async: true
  import LetorEcom.Factory
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
      email: "FAY@EMAIL.COM",
      first_name: nil,
      last_name: nil,
      phone: nil,
      location_id: nil
      # password: nil,
      # password_confirmation: nil
    }

    test "create_user/1 with valid data creates a user" do
      location = location_fixture()

      valid_attrs = %{
        address: "No 23 Okuzu Street Diobu",
        date_of_birth: ~D[2022-03-23],
        email: "somename@email.com",
        first_name: "first_name",
        last_name: "last_name",
        phone: "07030551375",
        location_id: location.id,
        password: "Password1@",
        password_confirmation: "Password1@"
      }

      assert {:ok, %{user: user}} = Account.register_customer(valid_attrs)
      assert user.address == "No 23 Okuzu Street Diobu"
      assert user.date_of_birth == ~D[2022-03-23]
      assert user.email == "somename@email.com"
      assert user.first_name == "first_name"
      assert user.last_name == "last_name"
      assert user.full_name == "first_name" <> " " <> "last_name"
      assert user.phone == "07030551375"
      assert user.role == "customer"
      assert user.password == "Password1@"
      assert user.password_confirmation == "Password1@"
      # assert user.password_hash == user.password_hash
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, :user, %Ecto.Changeset{}, _} = Account.register_customer(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # insert!(:user, location: location)
      user = user_fixture()

      random_value = Enum.random(1..100)

      update_attrs = %{
        address: "some updated address",
        date_of_birth: ~D[2022-03-23],
        email: "#{random_value}somename@email.com",
        first_name: "another_first_name",
        last_name: "another_last_name",
        phone: "08150598822",
        password: "Password1@",
        password_confirmation: "Password1@"
      }

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.address == "some updated address"
      assert user.date_of_birth == ~D[2022-03-23]
      assert user.email == "#{random_value}somename@email.com"
      assert user.first_name == "another_first_name"
      assert user.last_name == "another_last_name"
      assert user.full_name == "another_first_name" <> " " <> "another_last_name"
      assert user.phone == "08150598822"
      #  assert user.password_hash == user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # build(:user, location: location)
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
    end
  end

  describe "address book" do
    alias LetorEcom.Account.AddressBook

    @invalid_attrs %{
      address: nil,
      city: nil,
      area: nil,
      state: nil,
      zip_code: nil,
      coordinates: nil
      # user_id: user.id
    }

    test "create_address_book/1 with valid data creates an address book" do
      user = user_fixture()

      valid_attrs = %{
        address: "some address",
        city: "some city",
        area: "some area",
        state: "some state",
        zip_code: "some zip_code",
        coordinates: %Geo.Point{
          coordinates: {4.833813967530579, 7.0250130040393675},
          srid: 4326
        },
        user_id: user.id
      }

      assert {:ok, %AddressBook{} = address_book} = Account.create_address_book(valid_attrs)
      assert address_book.address == "some address"
      assert address_book.city == "some city"
      assert address_book.area == "some area"
      assert address_book.state == "some state"
      assert address_book.zip_code == "some zip_code"

      assert address_book.coordinates == %Geo.Point{
               coordinates: {4.833813967530579, 7.0250130040393675},
               srid: 4326
             }

      assert address_book.user_id == user.id
    end

    test "create_address_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_address_book(@invalid_attrs)
    end

    test "update_address_book/2 with valid data updates the address book" do
      user = user_fixture()
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # build(:user, location: location)
      user1 = user_fixture()
      # insert!(:address_book, user: user1)
      address_book = address_book_fixture()

      random_value = Enum.random(1..1000)

      update_attrs = %{
        address: "choba",
        city: "some updated city",
        area: "some updated area",
        state: "some updated state",
        zip_code: "some updated zip_code",
        coordinates: %Geo.Point{
          coordinates: {4.833813967530579, 7.0250130040393675},
          srid: 4326
        },
        user_id: user.id
      }

      assert {:ok, %AddressBook{} = address_book} =
               Account.update_address_book(address_book, update_attrs)

      assert address_book.address == "choba"
      assert address_book.city == "some updated city"
      assert address_book.area == "some updated area"
      assert address_book.state == "some updated state"
      assert address_book.zip_code == "some updated zip_code"

      assert address_book.coordinates == %Geo.Point{
               coordinates: {4.833813967530579, 7.0250130040393675},
               srid: 4326
             }
    end

    test "update_address/2 with invalid data returns error changeset" do
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # build(:user, location: location)
      user = user_fixture()
      # insert!(:address_book, user: user)
      address_book = address_book_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_address_book(address_book, @invalid_attrs)
    end

    test "delete_address/1 deletes the address" do
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # build(:user, location: location)
      user = user_fixture()
      # insert!(:address_book, user: user)
      address_book = address_book_fixture()
      assert {:ok, %AddressBook{}} = Account.delete_address_book(address_book)
    end
  end

  describe "refered_lists" do
    alias LetorEcom.Account.ReferedList

    @invalid_attrs %{date_activated: nil, refered_person_id: nil}

    test "create_refered_list/1 with valid data creates a refered_list" do
      user = user_fixture()

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
      user = user_fixture()
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # insert!(:user, location: location)
      user = user_fixture()
      # insert!(:refered_list, user: user1)
      refered_list = refered_list_fixture()

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
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # insert!(:user, location: location)
      user = user_fixture()
      # insert!(:refered_list, user: user1)
      refered_list = refered_list_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Account.update_refered_list(refered_list, @invalid_attrs)
    end

    test "delete_refered_list/1 deletes the refered_list" do
      # build(:ecommerce_control)
      ecommerce_control = ecommerce_control_fixture()
      # insert!(:pickup_centre, ecommerce_control: ecommerce_control)
      pickup_centre = pickup_centre_fixture()
      # insert!(:location, pickup_centre: pickup_centre)
      location = location_fixture()
      # insert!(:user, location: location)
      user = user_fixture()
      # insert!(:refered_list, user: user1)
      refered_list = refered_list_fixture()

      assert {:ok, %ReferedList{}} = Account.delete_refered_list(refered_list)
    end
  end

  describe "shopping_lists" do
    alias LetorEcom.Account.ShoppingList
    alias LetorEcom.Account.User
    alias LetorEcom.Catalogue.Item

    # LetorEcom.AccountFixtures
    import LetorEcom.Factory

    @invalid_attrs %{quantity: 42, title: nil, total: nil}

    test "create_shopping_list/1 with valid data creates a shopping_list" do
      valid_attrs = %{quantity: 42, title: "some title", total: Decimal.new("120.5")}

      assert {:ok, %ShoppingList{} = shopping_list} = Account.create_shopping_list(valid_attrs)
      assert shopping_list.quantity == 42
      assert shopping_list.title == "some title"
      assert shopping_list.total == Decimal.new("120.5")
    end

    test "create_shopping_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_shopping_list(@invalid_attrs)
    end

    test "update_shopping_list/2 with valid data updates the shopping_list" do
      shopping_list = shopping_list_fixture()
      user = user_fixture()
      item = item_fixture()

      update_attrs = %{
        quantity: 43,
        title: "Fruits Shopping list",
        total: Decimal.new("5181.5"),
        user_id: user.id,
        item_id: item.id
      }

      assert {:ok, %ShoppingList{} = shopping_list} =
               Account.update_shopping_list(shopping_list, update_attrs)

      assert shopping_list.quantity == 43
      assert shopping_list.title == "Fruits Shopping list"
      assert shopping_list.total == Decimal.new("5181.5")
      assert shopping_list.user_id == user.id
      assert shopping_list.item_id == item.id
    end

    # test "update_shopping_list/2 with invalid data returns error changeset" do
    # shopping_list = shopping_list_fixture()

    # assert {:error, %Ecto.Changeset{}} =
    #        Account.update_shopping_list(shopping_list, @invalid_attrs)

    # assert shopping_list == Account.get_shopping_list!(shopping_list.id)
    # end

    test "delete_shopping_list/1 deletes the shopping_list" do
      shopping_list = Repo.all(ShoppingList) |> List.first()
      assert {:ok, %ShoppingList{}} = Account.delete_shopping_list(shopping_list)
      assert_raise Ecto.NoResultsError, fn -> Account.get_shopping_list!(shopping_list.id) end
    end
  end

  describe "user_favs" do
    alias LetorEcom.Account.UserFav
    alias LetorEcom.Catalogue.Item

    # LetorEcom.AccountFixtures
    import LetorEcom.Factory

    @invalid_attrs %{item_id: nil, user_id: nil}

    test "create_user_fav/1 with valid data creates a user_fav" do
      item = item_fixture()

      valid_attrs = %{
        item_id: item.id
      }

      assert {:ok, %UserFav{} = user_fav} = Account.create_user_fav(valid_attrs)
    end

    test "create_user_fav/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user_fav(@invalid_attrs)
    end

    test "update_user_fav/2 with valid data updates the user_fav" do
      user_fav = user_fav_fixture()
      update_attrs = %{}

      assert {:ok, %UserFav{} = user_fav} = Account.update_user_fav(user_fav, update_attrs)
    end

    test "update_user_fav/2 with invalid data returns error changeset" do
      user_fav = user_fav_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user_fav(user_fav, @invalid_attrs)
      assert user_fav == Account.get_user_fav!(user_fav.id)
    end

    test "delete_user_fav/1 deletes the user_fav" do
      user_fav = user_fav_fixture()
      assert {:ok, %UserFav{}} = Account.delete_user_fav(user_fav)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user_fav!(user_fav.id) end
    end
  end

  describe "viewed_items" do
    alias LetorEcom.Account.{User, ViewedItem}
    alias LetorEcom.Catalogue.Item

    # LetorEcom.AccountFixtures
    import LetorEcom.Factory

    @invalid_attrs %{
     # item_id: item.id,
      #user_id: user.id
    }

    test "list_viewed_items/0 returns all viewed_items" do
      viewed_item = viewed_item_fixture()
      assert Account.list_viewed_items() |> List.first() == viewed_item
    end


    test "create_viewed_item/1 with valid data creates a viewed_item" do
      item = item_fixture()
      user = user_fixture()

      valid_attrs = %{
        item_id: item.id,
        user_id: user.id
             }

      assert {:ok, %ViewedItem{} = viewed_item} = Account.create_viewed_item(valid_attrs)
      assert viewed_item.item_id == item.id
      assert viewed_item.user_id == user.id
    end

    # test "create_viewed_item/1 with invalid data returns error changeset" do
    # assert {:error, %Ecto.Changeset{}} = Account.create_viewed_item(@invalid_attrs)
    # end

    test "update_viewed_item/2 with valid data updates the viewed_item" do
      viewed_item = viewed_item_fixture()
      item = item_fixture()
      user = user_fixture()

      update_attrs = %{
        item_id: item.id,
        user_id: user.id
      }

      assert {:ok, %ViewedItem{} = viewed_item} =
               Account.update_viewed_item(viewed_item, update_attrs)
               assert viewed_item.item_id == item.id
               assert viewed_item.user_id == user.id
    end

    test "update_viewed_item/2 with invalid data returns error changeset" do
      viewed_item = viewed_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_viewed_item(viewed_item, @invalid_attrs)
      assert viewed_item == Account.get_viewed_item!(viewed_item.id)
    end

    test "delete_viewed_item/1 deletes the viewed_item" do
      viewed_item = viewed_item_fixture()
      assert {:ok, %ViewedItem{}} = Account.delete_viewed_item(viewed_item)
      assert_raise Ecto.NoResultsError, fn -> Account.get_viewed_item!(viewed_item.id) end
    end
  end
end
