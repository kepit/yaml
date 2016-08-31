# Elixir YAML Library

## Installation

  1. Add `yaml` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:yaml, github: "kepit/yaml"}]
    end
    ```

  2. Ensure `yaml` is started before your application:

    ```elixir
    def application do
      [applications: [:yaml]]
    end
    ```
