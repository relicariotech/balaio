defmodule BalaioWeb.PageHTML do
  alias BalaioWeb.SurveyLive
  use BalaioWeb, :html
  use Phoenix.HTML
  alias Balaio.Catalog
  alias Balaio.Catalog.Business
  alias SurveyLive.Component
  alias BalaioWeb.SurveyLive.Component
  alias BalaioWeb.BusinessLive.BusinessComponent

  alias BalaioWeb.DemographicLive
  alias BalaioWeb.DemographicLive.Form

  import BalaioWeb.CustomComponents

  embed_templates "page_html/*"
end
