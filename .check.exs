[
  retry: false,
  tools: [
    {:deploy_assets, command: "mix assets.deploy"},
    {:install_cypress,
     command: "npm install cypress --save-dev --prefix assets",
     deps: [{:deploy_assets, status: :ok}]},
    {:cypress, command: "mix cypress.run"},
    {:npm_test, false},
    {:ex_coveralls,
     command: "mix coveralls.lcov",
     require_files: ["test/test_helper.exs"],
     env: %{"MIX_ENV" => "test"},
     deps: [{:install_cypress, status: :ok}]},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, enabled: false}
  ]
]
