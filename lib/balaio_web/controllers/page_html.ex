defmodule BalaioWeb.PageHTML do
  use BalaioWeb, :html
  use Phoenix.HTML

  import BalaioWeb.CustomComponents

  embed_templates "page_html/*"
end
