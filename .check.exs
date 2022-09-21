env = %{"MIX_ENV" => "test"}
require_files = ["test/test_helper.exs"]

[
  retry: false,
  tools: [
    {:compiler, command: "mix compile --warnings-as-errors", env: env},
    {:deploy_assets, command: "mix assets.deploy"},
    {:cypress, command: "mix cypress.run", deps: [{:deploy_assets, status: :ok}]},
    {:npm_test, false},
    {:ex_coveralls, command: "mix coveralls.lcov", require_files: require_files, env: env},
    {:credo, command: "mix credo --strict", env: env},
    {:ex_unit, enabled: false},
    {:dialyzer, env: env},
    {:formatter, env: env, command: "mix format"}
  ]
]
