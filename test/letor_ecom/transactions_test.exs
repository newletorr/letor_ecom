defmodule LetorEcom.TransactionsTest do
  use LetorEcom.DataCase
  import LetorEcom.Factory

  alias LetorEcom.Transactions

  describe "payments" do
    alias LetorEcom.Transactions.Payment

    # import LetorEcom.TransactionsFixtures

    @invalid_attrs %{
      amount: nil,
      authorization_url: nil,
      ip_address: nil,
      reference_code: nil,
      transaction_id: nil,
      verified: nil
    }

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Transactions.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Transactions.get_payment!(payment.id) == payment
    end

    test "make_order_payment/1 with valid data creates a payment" do
      order = order_fixture()

      valid_attrs = %{
        amount: "120.5",
        authorization_url: "some authorization_url",
        ip_address: "some ip_address",
        reference_code: "some reference_code",
        transaction_id: 42,
        verified: true
      }

      assert {:ok, %Payment{} = payment} = Transactions.make_order_payment(valid_attrs)
      assert payment.amount == Decimal.new("120.5")
      assert payment.authorization_url == "some authorization_url"
      assert payment.ip_address == "some ip_address"
      assert payment.reference_code == "some reference_code"
      assert payment.transaction_id == 42
      assert payment.verified == true
      assert payment.order_id == order.id
    end

    test "make_order_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.make_order_payment(@new_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()

      update_attrs = %{
        amount: "456.7",
        authorization_url: "some updated authorization_url",
        ip_address: "some updated ip_address",
        reference_code: "some updated reference_code",
        transaction_id: 43,
        verified: false
      }

      assert {:ok, %Payment{} = payment} = Transactions.update_payment(payment, update_attrs)
      assert payment.amount == Decimal.new("456.7")
      assert payment.authorization_url == "some updated authorization_url"
      assert payment.ip_address == "some updated ip_address"
      assert payment.reference_code == "some updated reference_code"
      assert payment.transaction_id == 43
      assert payment.verified == false
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_payment(payment, @invalid_attrs)
      assert payment == Transactions.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Transactions.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_payment!(payment.id) end
    end
  end

  describe "user_wallets" do
    alias LetorEcom.Transactions.UserWallet

    # import LetorEcom.TransactionsFixtures

    @invalid_attrs %{amount: nil, wallet_id: nil}

    test "create_user_wallet/1 with valid data creates a user_wallet" do
      valid_attrs = %{amount: Decimal.new("400"), wallet_id: "some wallet_id"}

      assert {:ok, %UserWallet{} = user_wallet} = Transactions.create_user_wallet(valid_attrs)
      assert user_wallet.amount == Decimal.new("400")
      assert user_wallet.wallet_id == "some wallet_id"
    end

    test "create_user_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_user_wallet(@invalid_attrs)
    end

    test "update_user_wallet/2 with valid data updates the user_wallet" do
      user_wallet = user_wallet_fixture()

      update_attrs = %{amount: Decimal.new("120.5"), wallet_id: "some updated wallet_id"}

      assert {:ok, %UserWallet{} = user_wallet} =
               Transactions.update_user_wallet(user_wallet, update_attrs)

      assert user_wallet.amount == Decimal.new("120.5")
      assert user_wallet.wallet_id == "some updated wallet_id"
    end

    test "update_user_wallet/2 with invalid data returns error changeset" do
      user_wallet = user_wallet_fixture()

     assert {:error, %Ecto.Changeset{}} =
              Transactions.update_user_wallet(user_wallet, @invalid_attrs)

      assert user_wallet == Transactions.get_user_wallet!(user_wallet.id)
    end

    test "delete_user_wallet/1 deletes the user_wallet" do
      user_wallet = user_wallet_fixture()
      assert {:ok, %UserWallet{}} = Transactions.delete_user_wallet(user_wallet)
    end
  end
end
