defmodule Balaio.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  alias Balaio.Repo

  alias Balaio.Catalog.Business
  alias Balaio.Catalog.Category

  @doc """
  Returns the list of business.

  ## Examples

      iex> list_business()
      [%Business{}, ...]

  """
  def list_business(filters \\ %{}) do
    Business
    |> apply_filters(filters)
    |> Repo.all()
    |> Repo.preload(:categories)
  end

  defp apply_filters(query, filters) when is_map(filters) do
    Enum.reduce(filters, query, fn
      # {:categories, categories}, query ->
      #   filter_by_categories(query, categories)

      {:categories, categories}, query
      when is_list(categories) ->
        # Assuming you have a many-to-many relationship with categories
        query
        |> join(:inner, [b], c in assoc(b, :categories))
        |> where([_, c], c.id in ^categories)

      {:is_delivery, is_delivery_value}, query when is_boolean(is_delivery_value) ->
        query |> where([b], b.is_delivery == ^is_delivery_value)

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single business.

  Raises `Ecto.NoResultsError` if the Business does not exist.

  ## Examples

      iex> get_business!(123)
      %Business{}

      iex> get_business!(456)
      ** (Ecto.NoResultsError)

  """
  def get_business!(id), do: Repo.get!(Business, id) |> Repo.preload([:categories])

  @doc """
  Creates a business.

  ## Examples

      iex> create_business(%{field: value})
      {:ok, %Business{}}

      iex> create_business(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def create_business(user, attrs \\ %{}) do
  #   user
  #   |> Ecto.build_assoc(:business)
  #   |> Business.changeset(attrs)
  #   |> Repo.insert()
  # end

  def create_business(attrs \\ %{}) do
    %Business{}
    |> Business.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a business.

  ## Examples

      iex> update_business(business, %{field: new_value})
      {:ok, %Business{}}

      iex> update_business(business, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_business(%Business{} = business, attrs) do
    business
    |> Business.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a business.

  ## Examples

      iex> delete_business(business)
      {:ok, %Business{}}

      iex> delete_business(business)
      {:error, %Ecto.Changeset{}}

  """
  def delete_business(%Business{} = business) do
    Repo.delete(business)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking business changes.

  ## Examples

      iex> change_business(business)
      %Ecto.Changeset{data: %Business{}}

  """
  def change_business(%Business{} = business, attrs \\ %{}) do
    Business.changeset(business, attrs)
  end

  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id), do: Repo.get!(Category, id)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{data: %Category{}}

  """
  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def categories_with_quantity_business(%{category_filter: category_filter}) do
    Category.Query.filter_by_category(category_filter)
    |> Category.Query.with_count_business()
    |> Repo.all()
  end

  def business_with_categories do
    Business.Query.filter_by_category()
    |> Repo.all()
  end

  def business_with_categories(%{
        category_filter: category_filter
      }) do
    Business.Query.filter_by_category(category_filter)
    |> Repo.all()
  end
end
