defmodule BalaioWeb.Router do
  use BalaioWeb, :router

  import BalaioWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BalaioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # See here https://hexdocs.pm/phoenix/routing.html#creating-new-pipelines
  pipeline :auth do
    plug :browser
    plug :require_authenticated_user
  end

  scope "/", BalaioWeb do
    pipe_through :browser

    # get "/", PageController, :home

    live_session :default,
      layout: {BalaioWeb.Layouts, :public} do
      live "/negocios", BusinessLive.Index, :index
      live "/negocio/:id", BusinessLive.Show, :show
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BalaioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:balaio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BalaioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BalaioWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{BalaioWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", BalaioWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{BalaioWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/survey", SurveyLive, :index
    end
  end

  # The Admin namespace
  # See here https://hexdocs.pm/phoenix/routing.html#scoped-routes
  live_session :admins,
    root_layout: {BalaioWeb.Layouts, :root},
    on_mount: {BalaioWeb.UserAuth, :mount_current_user} do
    scope "/admin", BalaioWeb.Admin do
      pipe_through :auth

      live "/business", BusinessLive.Index, :index
      live "/business/new", BusinessLive.Index, :new
      live "/business/:id/edit", BusinessLive.Index, :edit
      live "/business/:id", BusinessLive.Show, :show
      live "/business/:id/show/edit", BusinessLive.Show, :edit

      resources "/categories", CategoryController

      live "/dashboard", DashboardLive
    end
  end

  scope "/", BalaioWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{BalaioWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
