defmodule Balaio.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Balaio.Catalog` context.
  """

  @doc """
  Generate a business.
  """
  def business_fixture(attrs \\ %{}) do
    {:ok, business} =
      attrs
      |> Enum.into(%{
        name: "some name",
        address: "some address",
        description: "some description",
        category: "some category",
        phone: "some phone",
        thumbnail: "some thumbnail",
        menu_online: "some menu_online",
        menu_as_pdf: "some menu_as_pdf",
        social_media_link: "some social_media_link",
        is_delivery: true
      })
      |> Balaio.Catalog.create_business()

    business
  end

  @doc """
  Generate a business.
  """
  def business_fixture(attrs \\ %{}) do
    {:ok, business} =
      attrs
      |> Enum.into(%{
        name: "some name",
        address: "some address",
        description: "some description",
        category: "some category",
        phone: "some phone",
        thumbnail: "some thumbnail",
        is_delivery: true
      })
      |> Balaio.Catalog.create_business()

    business
  end

  @doc """
  Generate a unique category title.
  """
  def unique_category_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        title: unique_category_title()
      })
      |> Balaio.Catalog.create_category()

    category
  end
end
