defmodule BalaioWeb.BusinessLiveTest do
  use BalaioWeb.ConnCase

  import Phoenix.LiveViewTest
  import Balaio.CatalogFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_business(_) do
    business = business_fixture()
    %{business: business}
  end

  describe "Index" do
    setup [:create_business]

    test "lists all business", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/business")

      assert html =~ "Listing Business"
    end

    test "saves new business", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/business")

      assert index_live |> element("a", "New Business") |> render_click() =~
               "New Business"

      assert_patch(index_live, ~p"/business/new")

      assert index_live
             |> form("#business-form", business: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#business-form", business: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/business")

      html = render(index_live)
      assert html =~ "Business created successfully"
    end

    test "updates business in listing", %{conn: conn, business: business} do
      {:ok, index_live, _html} = live(conn, ~p"/business")

      assert index_live |> element("#business-#{business.id} a", "Edit") |> render_click() =~
               "Edit Business"

      assert_patch(index_live, ~p"/business/#{business}/edit")

      assert index_live
             |> form("#business-form", business: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#business-form", business: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/business")

      html = render(index_live)
      assert html =~ "Business updated successfully"
    end

    test "deletes business in listing", %{conn: conn, business: business} do
      {:ok, index_live, _html} = live(conn, ~p"/business")

      assert index_live |> element("#business-#{business.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#business-#{business.id}")
    end
  end

  describe "Show" do
    setup [:create_business]

    test "displays business", %{conn: conn, business: business} do
      {:ok, _show_live, html} = live(conn, ~p"/business/#{business}")

      assert html =~ "Show Business"
    end

    test "updates business within modal", %{conn: conn, business: business} do
      {:ok, show_live, _html} = live(conn, ~p"/business/#{business}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Business"

      assert_patch(show_live, ~p"/business/#{business}/show/edit")

      assert show_live
             |> form("#business-form", business: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#business-form", business: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/business/#{business}")

      html = render(show_live)
      assert html =~ "Business updated successfully"
    end
  end
end
