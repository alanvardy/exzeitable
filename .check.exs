[
  ## all available options with default values (see `mix check` docs for description)
  # skipped: true,
  # exit_status: true,
  # parallel: true,

  ## list of tools (see `mix check` docs for defaults)
  retry: false,
  tools: [
    ## curated tools may be disabled (e.g. the check for compilation warnings)
    # {:compiler, false},

    ## ...or adjusted (e.g. use one-line formatter for more compact credo output)
    # {:credo, command: "mix credo --format oneline"},

    ## custom new tools may be added (mix tasks or arbitrary commands)
    # {:my_mix_check, command: "mix release", env: %{"MIX_ENV" => "prod"}},
    # {:my_arbitrary_check, command: "npm test", cd: "assets"},

    {:cypress, command: "mix cypress.run", deps: [{:credo, status: :ok}]},
    {:dialyzer, deps: [{:credo, status: :ok}]},
    {:ex_doc, deps: [{:credo, status: :ok}]},
    {:npm_test, false},
    {:ex_coveralls,
     command: "mix coveralls.html",
     require_files: ["test/test_helper.exs"],
     env: %{"MIX_ENV" => "test"}, deps: [{:credo, status: :ok}]},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, command: "mix test", env: %{"MIX_ENV" => "test"}, deps: [{:credo, status: :ok}]}

    # {:my_arbitrary_script, command: ["my_script", "argument with spaces"], cd: "scripts"}
  ]
]
