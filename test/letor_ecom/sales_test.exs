defmodule LetorEcom.SalesTest do
  use LetorEcom.DataCase

  alias LetorEcom.Sales

  describe "sales" do
    alias LetorEcom.Sales.Sale
    alias LetorEcom.CustomerPurchases.CartItem

    # import LetorEcom.SalesFixtures

    @invalid_attrs %{
      buy_price: nil,
      cash_amount: nil,
      difference: nil,
      discount: nil,
      payment_method: nil,
      pos_amount: nil,
      pos_ref: nil,
      quantity: nil,
      reversed: nil,
      sales_amount: nil,
      sales_channel: nil,
      sales_price: nil,
      sales_status: nil,
      cart_item_id: nil
    }

    # test "list_sales/0 returns all sales" do
    # sale = sale_fixture()
    # assert Sales.list_sales() == [sale]
    # end

    # test "get_sale!/1 returns the sale with given id" do
    # sale = sale_fixture()
    # assert Sales.get_sale!(sale.id) == sale
    # end

    test "create_online_sale/1 with valid data creates a sale" do
      cart_item = cart_item_fixture()
      valid_attrs = %{

      quantity: 42,
      sales_price: "120.5",
      buy_price: "120.5",
      discount: "120.5",
      sales_channel: "some sales_channel",
      reversed: true,
      sales_amount: "120.5",
      sales_status: "some sales_status"
      }

      assert {:ok, %Sale{} = sale} = Sales.create_online_sales(valid_attrs)
      assert sale.buy_price == Decimal.new("120.5")
      assert sale.discount == Decimal.new("120.5")
      assert sale.quantity == 42
      assert sale.reversed == true
      assert sale.sales_amount == Decimal.new("120.5")
      assert sale.sales_channel == "some sales_channel"
      assert sale.sales_price == Decimal.new("120.5")
      assert sale.sales_status == "some sales_status"
      assert sale.cart_item_id == cart_item.id
    end

    test "create_online_sales/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_online_sales(@invalid_attrs)
    end

    test "update_sale/2 with valid data updates the sale" do
      sale = sale_fixture()

      update_attrs = %{
        buy_price: "456.7",
        cash_amount: "456.7",
        difference: "456.7",
        discount: "456.7",
        payment_method: "some updated payment_method",
        pos_amount: "456.7",
        pos_ref: "some updated pos_ref",
        quantity: 43,
        reversed: false,
        sales_amount: "456.7",
        sales_channel: "some updated sales_channel",
        sales_price: "456.7",
        sales_status: "some updated sales_status"
      }

      assert {:ok, %Sale{} = sale} = Sales.update_sale(sale, update_attrs)
      assert sale.buy_price == Decimal.new("456.7")
      assert sale.cash_amount == Decimal.new("456.7")
      assert sale.difference == Decimal.new("456.7")
      assert sale.discount == Decimal.new("456.7")
      assert sale.payment_method == "some updated payment_method"
      assert sale.pos_amount == Decimal.new("456.7")
      assert sale.pos_ref == "some updated pos_ref"
      assert sale.quantity == 43
      assert sale.reversed == false
      assert sale.sales_amount == Decimal.new("456.7")
      assert sale.sales_channel == "some updated sales_channel"
      assert sale.sales_price == Decimal.new("456.7")
      assert sale.sales_status == "some updated sales_status"
    end

    test "update_sale/2 with invalid data returns error changeset" do
      sale = sale_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_sale(sale, @invalid_attrs)
      assert sale == Sales.get_sale!(sale.id)
    end

    # test "delete_sale/1 deletes the sale" do
    # sale = sale_fixture()
    # assert {:ok, %Sale{}} = Sales.delete_sale(sale)
    # assert_raise Ecto.NoResultsError, fn -> Sales.get_sale!(sale.id) end
    # end

    # test "change_sale/1 returns a sale changeset" do
    # sale = sale_fixture()
    # assert %Ecto.Changeset{} = Sales.change_sale(sale)
    # end
  end

  describe "customer_info" do
    alias LetorEcom.Sales.CustomerInfo

    # import LetorEcom.SalesFixtures

    @invalid_attrs %{name: nil, phone: nil}

    # test "list_customer_info/0 returns all customer_info" do
    # customer_info = customer_info_fixture()

    # assert Sales.list_customer_info() == [customer_info]
    # end

    # test "get_customer_info!/1 returns the customer_info with given id" do
    # customer_info = customer_info_fixture()

    # assert Sales.get_customer_info!(customer_info.id) == customer_info
    # end

    test "create_customer_info/1 with valid data creates a customer_info" do
      valid_attrs = %{name: "some name", phone: "some phone"}

      assert {:ok, %CustomerInfo{} = customer_info} = Sales.create_customer_info(valid_attrs)
      #assert customer_info.email == "some email"
      assert customer_info.name == "some name"
      assert customer_info.phone == "some phone"
    end

    test "create_customer_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_customer_info(@invalid_attrs)
    end

    test "update_customer_info/2 with valid data updates the customer_info" do
      customer_info = customer_info_fixture()

      update_attrs = %{
        #email: "some updated email",
        name: "some updated name",
        phone: "some updated phone"
      }

      assert {:ok, %CustomerInfo{} = customer_info} =
               Sales.update_customer_info(customer_info, update_attrs)

      #assert customer_info.email == "some updated email"
      assert customer_info.name == "some updated name"
      assert customer_info.phone == "some updated phone"
    end

    test "update_customer_info/2 with invalid data returns error changeset" do
      customer_info = customer_info_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Sales.update_customer_info(customer_info, @invalid_attrs)

      assert customer_info == Sales.get_customer_info!(customer_info.id)
    end

    # test "delete_customer_info/1 deletes the customer_info" do
    # customer_info = customer_info_fixture()

    # assert {:ok, %CustomerInfo{}} = Sales.delete_customer_info(customer_info)
    # assert_raise Ecto.NoResultsError, fn -> Sales.get_customer_info!(customer_info.id) end
    # end

    # test "change_customer_info/1 returns a customer_info changeset" do
    # customer_info = customer_info_fixture()

    # assert %Ecto.Changeset{} = Sales.change_customer_info(customer_info)
    # end
  end

  describe "instore_sales" do
    alias LetorEcom.Sales.InstoreSale

    # import LetorEcom.SalesFixtures

    @invalid_attrs %{item_price: nil, quantity: nil, sales_amount: nil, staff_id: nil}

    # test "list_instore_sales/0 returns all instore_sales" do
    # instore_sale = instore_sale_fixture()
    # assert Sales.list_instore_sales() == [instore_sale]
    # end

    # test "get_instore_sale!/1 returns the instore_sale with given id" do
    # instore_sale = instore_sale_fixture()
    # assert Sales.get_instore_sale!(instore_sale.id) == instore_sale
    # end

    test "create_instore_sale/1 with valid data creates a instore_sale" do
      staff = staff_fixture()
      valid_attrs = %{item_price: "120.5", quantity: 42, sales_amount: "120.5", staff_id: staff.id}

      assert {:ok, %InstoreSale{} = instore_sale} = Sales.create_instore_sale(valid_attrs)
      assert instore_sale.item_price == Decimal.new("120.5")
      assert instore_sale.quantity == 42
      assert instore_sale.sales_amount == Decimal.new("120.5")
      assert instore_sale.staff_id == staff.id
    end

    test "create_instore_sale/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sales.create_instore_sale(@invalid_attrs)
    end

    test "update_instore_sale/2 with valid data updates the instore_sale" do
      instore_sale = instore_sale_fixture()
      update_attrs = %{item_price: "456.7", quantity: 43, sales_amount: "456.7"}

      assert {:ok, %InstoreSale{} = instore_sale} =
               Sales.update_instore_sale(instore_sale, update_attrs)

      assert instore_sale.item_price == Decimal.new("456.7")
      assert instore_sale.quantity == 43
      assert instore_sale.sales_amount == Decimal.new("456.7")
    end

    test "update_instore_sale/2 with invalid data returns error changeset" do
      instore_sale = instore_sale_fixture()
      assert {:error, %Ecto.Changeset{}} = Sales.update_instore_sale(instore_sale, @invalid_attrs)
      assert instore_sale == Sales.get_instore_sale!(instore_sale.id)
    end

    # test "delete_instore_sale/1 deletes the instore_sale" do
    # instore_sale = instore_sale_fixture()
    # assert {:ok, %InstoreSale{}} = Sales.delete_instore_sale(instore_sale)
    # assert_raise Ecto.NoResultsError, fn -> Sales.get_instore_sale!(instore_sale.id) end
    # end

    # test "change_instore_sale/1 returns a instore_sale changeset" do
    # instore_sale = Repo.all(InstoreSale) |> List.first()
    # assert %Ecto.Changeset{} = Sales.change_instore_sale(instore_sale)
    # end
  end
end
