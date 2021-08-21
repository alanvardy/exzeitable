[
  retry: false,
  tools: [
    {:cypress, command: "mix cypress.run"},
    {:npm_test, false},
    {:ex_coveralls,
     command: "mix coveralls.html",
     require_files: ["test/test_helper.exs"],
     env: %{"MIX_ENV" => "test"}},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, command: "mix test", env: %{"MIX_ENV" => "test"}}
  ]
]
