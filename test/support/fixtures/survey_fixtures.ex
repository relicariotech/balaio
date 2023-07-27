defmodule Balaio.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Balaio.Survey` context.
  """

  @doc """
  Generate a demographic.
  """
  def demographic_fixture(attrs \\ %{}) do
    {:ok, demographic} =
      attrs
      |> Enum.into(%{
        gender: "some gender",
        year_of_birth: 42
      })
      |> Balaio.Survey.create_demographic()

    demographic
  end
end
