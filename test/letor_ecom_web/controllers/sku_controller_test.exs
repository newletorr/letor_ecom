defmodule LetorEcomWeb.SkuControllerTest do
  use LetorEcomWeb.ConnCase

  import LetorEcom.CatalogueFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all sku", %{conn: conn} do
      conn = get(conn, Routes.sku_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Sku"
    end
  end

  describe "new sku" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.sku_path(conn, :new))
      assert html_response(conn, 200) =~ "New Sku"
    end
  end

  describe "create sku" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.sku_path(conn, :create), sku: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.sku_path(conn, :show, id)

      conn = get(conn, Routes.sku_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Sku"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.sku_path(conn, :create), sku: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Sku"
    end
  end

  describe "edit sku" do
    setup [:create_sku]

    test "renders form for editing chosen sku", %{conn: conn, sku: sku} do
      conn = get(conn, Routes.sku_path(conn, :edit, sku))
      assert html_response(conn, 200) =~ "Edit Sku"
    end
  end

  describe "update sku" do
    setup [:create_sku]

    test "redirects when data is valid", %{conn: conn, sku: sku} do
      conn = put(conn, Routes.sku_path(conn, :update, sku), sku: @update_attrs)
      assert redirected_to(conn) == Routes.sku_path(conn, :show, sku)

      conn = get(conn, Routes.sku_path(conn, :show, sku))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, sku: sku} do
      conn = put(conn, Routes.sku_path(conn, :update, sku), sku: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Sku"
    end
  end

  describe "delete sku" do
    setup [:create_sku]

    test "deletes chosen sku", %{conn: conn, sku: sku} do
      conn = delete(conn, Routes.sku_path(conn, :delete, sku))
      assert redirected_to(conn) == Routes.sku_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.sku_path(conn, :show, sku))
      end
    end
  end

  defp create_sku(_) do
    sku = sku_fixture()
    %{sku: sku}
  end
end
