defmodule Balaio.Survey do
  @moduledoc """
  The Survey context.
  """

  import Ecto.Query, warn: false
  alias Balaio.Repo

  alias Balaio.Survey.Demographic

  @doc """
  Returns the list of demographics.

  ## Examples

      iex> list_demographics()
      [%Demographic{}, ...]

  """
  def list_demographics do
    Repo.all(Demographic)
  end

  def get_demographic_by_user(user) do
    Demographic.Query.for_user(user)
    |> Repo.one()
  end

  @doc """
  Gets a single demographic.

  Raises `Ecto.NoResultsError` if the Demographic does not exist.

  ## Examples

      iex> get_demographic!(123)
      %Demographic{}

      iex> get_demographic!(456)
      ** (Ecto.NoResultsError)

  """
  def get_demographic!(id), do: Repo.get!(Demographic, id)

  @doc """
  Creates a demographic.

  ## Examples

      iex> create_demographic(%{field: value})
      {:ok, %Demographic{}}

      iex> create_demographic(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_demographic(attrs \\ %{}) do
    %Demographic{}
    |> Demographic.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a demographic.

  ## Examples

      iex> update_demographic(demographic, %{field: new_value})
      {:ok, %Demographic{}}

      iex> update_demographic(demographic, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_demographic(%Demographic{} = demographic, attrs) do
    demographic
    |> Demographic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a demographic.

  ## Examples

      iex> delete_demographic(demographic)
      {:ok, %Demographic{}}

      iex> delete_demographic(demographic)
      {:error, %Ecto.Changeset{}}

  """
  def delete_demographic(%Demographic{} = demographic) do
    Repo.delete(demographic)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking demographic changes.

  ## Examples

      iex> change_demographic(demographic)
      %Ecto.Changeset{data: %Demographic{}}

  """
  def change_demographic(%Demographic{} = demographic, attrs \\ %{}) do
    Demographic.changeset(demographic, attrs)
  end
end
