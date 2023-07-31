defmodule BalaioWeb.BusinessLive.FormComponent do
  use BalaioWeb, :live_component

  alias Balaio.Catalog

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
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:category]} type="text" label="Category" />
        <.input field={@form[:is_delivery]} type="checkbox" label="Is delivery" />
        <.input
          field={@form[:category_ids]}
          type="select"
          multiple={true}
          options={category_opts(@form)}
        />

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
    changeset = Catalog.change_business(business)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> allow_upload(
       :image,
       accept: ~w(.jpg .jpeg .png),
       max_entries: 1,
       max_file_size: 9_000_000,
       auto_upload: true
     )}
  end

  @impl true
  def handle_event("validate", %{"business" => business_params}, socket) do
    changeset =
      socket.assigns.business
      |> Catalog.change_business(business_params)
      |> Map.put(:categories, business_params["category_ids"])
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"business" => business_params}, socket) do
    save_business(socket, socket.assigns.action, business_params)
  end

  def category_opts(nil), do: category_opts(%{source: %Ecto.Changeset{}})

  def category_opts(%{source: changeset} = _form) do
    existing_ids =
      changeset
      |> Ecto.Changeset.get_change(:categories, [])
      |> Enum.map(& &1.data.id)

    for cat <- Balaio.Catalog.list_categories(),
        do: [key: cat.title, value: cat.id, selected: cat.id in existing_ids]
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

    category_ids = Enum.map(business_params["category_ids"])

    business_params = Map.put(business_params, "category_ids", category_ids)

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

    category_ids = Enum.map(business_params["category_ids"])

    business_params = Map.put(business_params, "category_ids", category_ids)

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
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
