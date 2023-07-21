defmodule Balaio.CatalogTest do
  use Balaio.DataCase

  alias Balaio.Catalog

  describe "business" do
    alias Balaio.Catalog.Business

    import Balaio.CatalogFixtures

    @invalid_attrs %{name: nil, address: nil, description: nil, category: nil, phone: nil, thumbnail: nil, menu_online: nil, menu_as_pdf: nil, social_media_link: nil, is_delivery: nil}

    test "list_business/0 returns all business" do
      business = business_fixture()
      assert Catalog.list_business() == [business]
    end

    test "get_business!/1 returns the business with given id" do
      business = business_fixture()
      assert Catalog.get_business!(business.id) == business
    end

    test "create_business/1 with valid data creates a business" do
      valid_attrs = %{name: "some name", address: "some address", description: "some description", category: "some category", phone: "some phone", thumbnail: "some thumbnail", menu_online: "some menu_online", menu_as_pdf: "some menu_as_pdf", social_media_link: "some social_media_link", is_delivery: true}

      assert {:ok, %Business{} = business} = Catalog.create_business(valid_attrs)
      assert business.name == "some name"
      assert business.address == "some address"
      assert business.description == "some description"
      assert business.category == "some category"
      assert business.phone == "some phone"
      assert business.thumbnail == "some thumbnail"
      assert business.menu_online == "some menu_online"
      assert business.menu_as_pdf == "some menu_as_pdf"
      assert business.social_media_link == "some social_media_link"
      assert business.is_delivery == true
    end

    test "create_business/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Catalog.create_business(@invalid_attrs)
    end

    test "update_business/2 with valid data updates the business" do
      business = business_fixture()
      update_attrs = %{name: "some updated name", address: "some updated address", description: "some updated description", category: "some updated category", phone: "some updated phone", thumbnail: "some updated thumbnail", menu_online: "some updated menu_online", menu_as_pdf: "some updated menu_as_pdf", social_media_link: "some updated social_media_link", is_delivery: false}

      assert {:ok, %Business{} = business} = Catalog.update_business(business, update_attrs)
      assert business.name == "some updated name"
      assert business.address == "some updated address"
      assert business.description == "some updated description"
      assert business.category == "some updated category"
      assert business.phone == "some updated phone"
      assert business.thumbnail == "some updated thumbnail"
      assert business.menu_online == "some updated menu_online"
      assert business.menu_as_pdf == "some updated menu_as_pdf"
      assert business.social_media_link == "some updated social_media_link"
      assert business.is_delivery == false
    end

    test "update_business/2 with invalid data returns error changeset" do
      business = business_fixture()
      assert {:error, %Ecto.Changeset{}} = Catalog.update_business(business, @invalid_attrs)
      assert business == Catalog.get_business!(business.id)
    end

    test "delete_business/1 deletes the business" do
      business = business_fixture()
      assert {:ok, %Business{}} = Catalog.delete_business(business)
      assert_raise Ecto.NoResultsError, fn -> Catalog.get_business!(business.id) end
    end

    test "change_business/1 returns a business changeset" do
      business = business_fixture()
      assert %Ecto.Changeset{} = Catalog.change_business(business)
    end
  end
end
