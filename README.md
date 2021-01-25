# Rush statistics
Look at the `demo.mp4` file.

### Pre-requisites
This application requires [PostgreSQL](https://www.postgresql.org/) to be installed (version 13). 

### Installation and running this solution
Install the following programming language dependencies:
- erlang 23.2
- elixir 1.11.3
- nodejs 14.15.4

Or use the [asdf tool](https://github.com/asdf-vm/asdf) to install everything with a single command:

```
asdf install
```

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Insert the seed data (from `rushing.json`) into the database with `mix run priv/repo/seeds.exs`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
