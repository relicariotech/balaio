# balaio

balaio is a simple web application to manage a list local Business and its Products, Services and contacts. It was built using Elixir, Phoenix, and LiveView.

You can use balaio to develop your own local guide, or to manage a list of local businesses and their products and services. Feel free to fork and customize it to your needs.

## Features

## Running the projetc

To run the project, you need to have Elixir and Phoenix installed. You can follow the instructions on the [official website](https://www.phoenixframework.org/).

### 1 - postgres with docker-compose

There's a docker-compose.yml file with a Postgres database configuration. You can run the database with the following command:

```
docker-compose up -d
```

It will spin up a Postgres database on port 5432. You can change the port if necessary. The Phoenix application will create the `balaio_dev` database and also the `balaio_test` when needed.

### 2 - create the database

Execute the `mix ecto.reset`. It will create the database, run the migrations and seed all necessary data. See the `aliases` function on `mix.exs` to understand the chain of commands:

```elixir
"ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
"ecto.reset": ["ecto.drop", "ecto.setup"]
```

### 3 - start the application

Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
