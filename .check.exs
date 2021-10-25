[
  retry: false,
  tools: [
    {:docker_up, command: "docker-compose up -d"},
    {:deploy_assets, command: "mix assets.deploy", deps: [{:docker_up, status: :ok}]},
    {:install_cypress,
     command: "npm install cypress --save-dev --prefix assets",
     deps: [{:deploy_assets, status: :ok}]},
    {:cypress, command: "mix cypress.run", deps: [{:docker_up, status: :ok}]},
    {:npm_test, false},
    {:ex_coveralls,
     command: "mix coveralls.html",
     require_files: ["test/test_helper.exs"],
     env: %{"MIX_ENV" => "test"},
     deps: [{:install_cypress, status: :ok}]},
    {:credo, command: "mix credo --strict"},
    {:ex_unit,
     command: "mix test", env: %{"MIX_ENV" => "test"}, deps: [{:docker_up, status: :ok}]}
  ]
]
