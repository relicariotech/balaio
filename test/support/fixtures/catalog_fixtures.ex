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
end
