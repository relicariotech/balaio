defmodule BalaioWeb.BusinessLive.FormComponent do
  use BalaioWeb, :live_component

  alias Balaio.Catalog
  alias Balaio.Catalog.BusinessCategory
  alias Balaio.Catalog.Category

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage business records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="business-form"
        multipart
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:is_delivery]} type="checkbox" label="Is delivery" />

        <h1 class="text-md font-semibold leading-8 text-zinc-800">
          Categories
        </h1>

        <div id="categories" class="space-y-2">
          <.inputs_for :let={b_category} field={@form[:business_categories]}>
            <div class="flex space-x-2 drag-item">
              <input type="hidden" name="business[categories_order][]" value={b_category.index} />

              <.input
                type="select"
                field={b_category[:category_id]}
                placeholder="Category"
                options={@categories}
              />

              <label class="cursor-pointer">
                <input
                  type="checkbox"
                  name="business[categories_delete][]"
                  value={b_category.index}
                  class="hidden"
                />
                <.icon name="hero-trash" class="w-4 h-4 relative top-2" />
              </label>
            </div>
          </.inputs_for>
        </div>
        <:actions>
          <label class="block cursor-pointer">
            <input type="checkbox" name="business[categories_order][]" class="hidden" />
            <.icon name="hero-plus-circle" /> add more
          </label>
        </:actions>
        <div id="images">
          <div
            class="p-4 border-2 border-dashed border-slate-300 rounded-md text-center text-slate-600"
            phx-drop-target={@uploads.image.ref}
          >
            <div class="flex flex-row items-center justify-center">
              <.live_file_input upload={@uploads.image} />
              <span class="font-semibold text-slate-500">or drag and drop here</span>
            </div>
          </div>
        </div>

        <div class="mt-4 flex flex-row flex-wrap justify-start content-start items-start gap-2">
          <div
            :for={entry <- @uploads.image.entries}
            class="flex flex-col items-center justify-start space-y-1"
          >
            <div class="w-32 h-32 overflow-clip">
              <.live_img_preview entry={entry} />
            </div>

            <div class="w-full">
              <div class="mb-2 text-xs font-semibold inline-block text-slate-600">
                <%= entry.progress %>%
              </div>
              <div class="flex h-2 overflow-hidden text-base bg-slate-200 rounded-lg mb-2">
                <span style={"width: #{entry.progress}%"} class="shadow-md bg-slate-500"></span>
              </div>
              <.error :for={err <- upload_errors(@uploads.image, entry)}>
                <%= Phoenix.Naming.humanize(err) %>
              </.error>
            </div>
            <a phx-click="cancel" phx-target={@myself} phx-value-ref={entry.ref}>
              <.icon name="hero-trash" />
            </a>
          </div>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Business</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{business: business} = assigns, socket) do
    business_changeset = Catalog.change_business(business)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(business_changeset)
     |> assign_categories()
     |> allow_upload(
       :image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 9_000_000,
       auto_upload: true
     )}
  end

  defp assign_categories(socket) do
    categories =
      Catalog.list_categories()
      |> Enum.map(&{&1.title, &1.id})

    assign(socket, :categories, categories)
  end

  @impl true
  def handle_event("validate", %{"business" => business_params} = _params, socket) do
    changeset =
      socket.assigns.business
      |> Catalog.change_business(business_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"business" => business_params} = _param, socket) do
    save_business(socket, socket.assigns.action, business_params)
  end

  def params_with_image(socket, params) do
    path =
      socket
      |> consume_uploaded_entries(:image, &upload_static_file/2)
      |> List.first()

    Map.put(params, "thumbnail", path)
  end

  defp upload_static_file(%{path: path}, _entry) do
    filename = Path.basename(path)
    dest = Path.join("priv/static/images", filename)
    File.cp!(path, dest)

    {:ok, ~p"/images/#{filename}"}
  end

  defp save_business(socket, :edit, business_params) do
    business_params = params_with_image(socket, business_params)

    case Catalog.update_business(socket.assigns.business, business_params) do
      {:ok, business} ->
        notify_parent({:saved, business})

        {:noreply,
         socket
         |> put_flash(:info, "Business updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_business(socket, :new, business_params) do
    business_params = params_with_image(socket, business_params)

    case Catalog.create_business(business_params) do
      {:ok, business} ->
        notify_parent({:saved, business})

        {:noreply,
         socket
         |> put_flash(:info, "Business created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    if Ecto.Changeset.get_field(changeset, :business_categories) == [] do
      business_category = %BusinessCategory{}

      changeset = Ecto.Changeset.put_change(changeset, :business_categories, [business_category])

      assign(socket, :form, to_form(changeset))
    else
      assign(socket, :form, to_form(changeset))
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
