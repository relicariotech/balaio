defmodule BalaioWeb.BusinessLive.Index do
  use BalaioWeb, :live_view

  alias Balaio.Catalog
  alias Balaio.Catalog.Business

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        filter: %{categories: []},
        businesses: Catalog.list_business()
      )

    {:ok, socket, temporary_assigns: [businesses: []]}
  end

  def handle_event("filter", %{"categories" => categories}, socket) do
    filter = %{categories: categories}

    businesses = Catalog.list_business(filter)

    {:noreply, assign(socket, businesses: businesses, filter: filter)}
  end

  def business_items(assigns) do
    ~H"""
    <div :for={business <- @businesses} class="flex flex-col">
      <!-- Item -->
      <div class="[&:nth-child(-n+12)]:-order-1 border-b border-gray-200 group">
        <div class="px-4 py-6">
          <div class="sm:flex items-center space-y-3 sm:space-y-0 sm:space-x-5">
            <div class="shrink-0">
              <img
                class="rounded-md"
                src={business.thumbnail}
                width="56"
                height="56"
                alt={business.name}
              />
            </div>
            <div class="grow lg:flex items-center justify-between space-y-5 lg:space-x-2 lg:space-y-0">
              <div>
                <div class="-m-1 mb-2">
                  <div
                    :for={category <- business.categories}
                    class="text-xs text-gray-500 font-medium inline-flex px-2 py-0.5 bg-gray-100 rounded-md m-1 whitespace-nowrap"
                  >
                    <%= category.title %>
                  </div>
                </div>
                <div class="mb-2">
                  <.link navigate={~p"/negocio/#{business}"} class="text-lg text-gray-800 font-bold">
                    <%= business.name %>
                  </.link>
                </div>
                <div class="-m-1">
                  <a
                    class="text-xs text-gray-500 font-medium inline-flex px-2 py-0.5 bg-gray-100 hover:text-gray-600 rounded-md m-1 whitespace-nowrap transition duration-150 ease-in-out"
                    href="#0"
                  >
                    Full Time
                  </a>
                  <a
                    class="text-xs text-gray-500 font-medium inline-flex px-2 py-0.5 bg-gray-100 hover:text-gray-600 rounded-md m-1 whitespace-nowrap transition duration-150 ease-in-out"
                    href="#0"
                  >
                    🌎 Remote
                  </a>
                  <a
                    class="text-xs text-gray-500 font-medium inline-flex px-2 py-0.5 bg-gray-100 hover:text-gray-600 rounded-md m-1 whitespace-nowrap transition duration-150 ease-in-out"
                    href="#0"
                  >
                    <.icon name="hero-map-pin" class="w-4 h-4 text-gray-500" /> <%= business.address %>
                  </a>
                  <a
                    class="text-xs text-gray-500 font-medium inline-flex px-2 py-0.5 bg-gray-100 hover:text-gray-600 rounded-md m-1 whitespace-nowrap transition duration-150 ease-in-out"
                    href="#0"
                  >
                    <.icon name="hero-phone" class="w-4 h-4 text-gray-500" /> <%= business.phone %>
                  </a>
                </div>
              </div>

              <div class="min-w-[120px] flex items-center lg:justify-end space-x-3 lg:space-x-0">
                <div class="group-hover:lg:block">
                  <.link
                    href={~p"/negocio/#{business}"}
                    class="btn-sm py-1.5 px-3 text-white bg-indigo-500 hover:bg-indigo-600 group shadow-sm"
                  >
                    Leia mais
                    <span class="tracking-normal text-indigo-200 group-hover:translate-x-0.5 transition-transform duration-150 ease-in-out ml-1">
                      <.icon name="hero-arrow-right" class="w-3 h-3" />
                    </span>
                  </.link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- End Item -->
    </div>
    """
  end

  def index_sidebar(assigns) do
    ~H"""
    <aside class="mb-8 md:mb-0 md:w-64 lg:w-72 md:ml-12 lg:ml-20 md:shrink-0 md:order-1">
      <div class="sticky top-8">
        <div class="relative bg-gray-50 rounded-xl border border-gray-200 p-5">
          <div class="absolute top-5 right-5 leading-none">
            <button class="text-sm font-medium text-indigo-500 hover:underline">
              Clear
            </button>
          </div>

          <div class="grid grid-cols-2 md:grid-cols-1 gap-6">
            <!-- Group 1 -->
            <div>
              <form phx-change="filter">
                <div class="text-sm text-gray-800 font-semibold mb-3">Categorias</div>
                <ul class="space-y-2">
                  <%= for category <- Balaio.Catalog.list_categories() do %>
                    <li>
                      <label class="flex items-center">
                        <input
                          type="checkbox"
                          name="categories[]"
                          value={category.id}
                          id={"#{category.id}-business"}
                          checked={category.id in @filter.categories}
                          class="form-checkbox"
                        />
                        <span class="text-sm text-gray-600 ml-2"><%= category.title %></span>
                      </label>
                    </li>
                  <% end %>
                  <%!-- <input type="hidden" name="categories[]" value="" /> --%>
                </ul>
              </form>
            </div>
            <!-- Group 2 -->
            <div>
              <div class="text-sm text-gray-800 font-semibold mb-3">Job Roles</div>
              <ul class="space-y-2">
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" checked />
                    <span class="text-sm text-gray-600 ml-2">Programming</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">Design</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">Management / Finance</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">Customer Support</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">Sales / Marketing</span>
                  </label>
                </li>
              </ul>
            </div>
            <!-- Group 3 -->
            <div>
              <div class="text-sm text-gray-800 font-semibold mb-3">Delivery</div>
              <div class="flex items-center" x-data="{ checked: false }">
                <div class="form-switch">
                  <input type="checkbox" id="remote-toggle" class="sr-only" x-model="checked" />
                  <label class="bg-gray-300" for="remote-toggle">
                    <span class="bg-white shadow-sm" aria-hidden="true"></span>
                    <span class="sr-only">Remote Only</span>
                  </label>
                </div>
                <div class="text-sm text-gray-400 italic ml-2" x-text="checked ? 'On' : 'Off'"></div>
              </div>
            </div>
            <!-- Group 3 -->
            <div>
              <div class="text-sm text-gray-800 font-semibold mb-3">Salary Range</div>
              <ul class="space-y-2">
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">$20K - $50K</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">$50K - $100K</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">&gt; $100K</span>
                  </label>
                </li>
                <li>
                  <label class="flex items-center">
                    <input type="checkbox" class="form-checkbox" />
                    <span class="text-sm text-gray-600 ml-2">Drawing / Painting</span>
                  </label>
                </li>
              </ul>
            </div>
            <!-- Group 4 -->
            <div>
              <div class="text-sm text-gray-800 font-semibold mb-3">Cidade</div>
              <label class="sr-only">Location</label>
              <select class="form-select w-full">
                <option>Curionópolis</option>
                <option>Parauapebas</option>
                <option>Canaã dos Carajás</option>
                <option>Marabá</option>
                <option>Xinguara</option>
              </select>
            </div>
          </div>
        </div>
        <%!-- <.feature>
          Agências Bancárias
          <%= for business <- Balaio.Catalog.filter_by_category("fdfb443f-762f-496e-b4f4-619696def356") do %>
            <!-- Item -->
            <div class="[&:nth-child(-n+12)]:-order-1 border-b border-gray-200 group">
              <div class="px-4 py-6">
                <div class="sm:flex items-center space-y-3 sm:space-y-0 sm:space-x-5">
                  <div class="shrink-0">
                    <img
                      class="rounded-md bg-white"
                      src={business.thumbnail}
                      width="56"
                      height="56"
                      alt={business.name}
                    />
                  </div>
                  <div class="grow lg:flex items-center justify-between space-y-5 lg:space-x-2 lg:space-y-0">
                    <div>
                      <div class="mb-2">
                        <.link
                          navigate={~p"/negocio/#{business}"}
                          class="text-lg text-gray-800 font-bold"
                        >
                          <%= business.name %>
                        </.link>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!-- End Item -->
          <% end %>
        </.feature> --%>
      </div>
    </aside>
    """
  end

  def testimonials(assigns) do
    ~H"""
    <div>
      <h2 class="text-3xl font-bold font-inter mb-10">O que dizem nossos clientes</h2>
      <!-- Testimonials container -->
      <div class="space-y-10">
        <!-- Item -->
        <div class="p-5 rounded-xl bg-teal-50 border border-teal-200 odd:rotate-1 even:-rotate-1 hover:rotate-0 transition duration-150 ease-in-out">
          <div class="flex items-center space-x-5">
            <div class="relative shrink-0">
              <img
                class="rounded-full"
                src={~p"/images/whelyson.jpeg"}
                width="102"
                height="102"
                alt="Whelyson Silveira, CEO na Engenharia Silveira"
              />
              <svg
                class="absolute top-0 right-0 fill-indigo-400"
                width="26"
                height="17"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path d="M0 16.026h8.092l6.888-16h-4.592L0 16.026Zm11.02 0h8.092L26 .026h-4.65l-10.33 16Z" />
              </svg>
            </div>
            <figure>
              <blockquote class="text-lg font-bold m-0 pb-1">
                <p>
                  Eu encontro tudo que preciso aqui no balaio.
                </p>
              </blockquote>
              <figcaption class="text-sm font-medium">
                Whelyson Silveira, CEO
                <a class="text-teal-500 hover:underline" href="http://engenhariasilveira.com.br">
                  Silveira Engenharia
                </a>
              </figcaption>
            </figure>
          </div>
        </div>
        <!-- Item -->
        <div class="p-5 rounded-xl bg-sky-50 border border-sky-200 odd:rotate-1 even:-rotate-1 hover:rotate-0 transition duration-150 ease-in-out">
          <div class="flex items-center space-x-5">
            <div class="relative shrink-0">
              <img
                class="rounded-full"
                src={~p"/images/logo.svg"}
                width="102"
                height="102"
                alt="Testimonial 02"
              />
              <svg
                class="absolute top-0 right-0 fill-indigo-400"
                width="26"
                height="17"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path d="M0 16.026h8.092l6.888-16h-4.592L0 16.026Zm11.02 0h8.092L26 .026h-4.65l-10.33 16Z" />
              </svg>
            </div>
            <figure>
              <blockquote class="text-lg font-bold m-0 pb-1">
                <p>
                  É a soluçao perfeita pra quem tem pressa e precisa encontrar os Produtos e Serviços da cidade.
                </p>
              </blockquote>
              <figcaption class="text-sm font-medium">
                Annie Patrick, CEO <a class="text-sky-500 hover:underline" href="#0">TrueThing</a>
              </figcaption>
            </figure>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
