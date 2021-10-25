[
  retry: false,
  tools: [
    {:deploy_assets, command: "mix assets.deploy"},
    {:cypress, command: "mix cypress.run", deps: [{:deploy_assets, status: :ok}]},
    {:npm_test, false},
    {:ex_coveralls,
     command: "mix coveralls.lcov",
     require_files: ["test/test_helper.exs"],
     env: %{"MIX_ENV" => "test"}},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, enabled: false}
  ]
]
