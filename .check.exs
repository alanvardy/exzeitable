[
  retry: false,
  tools: [
    {:npm_deploy, command: "npm run deploy --prefix ./assets"},
    {:phx_digest, command: "mix phx.digest", deps: [{:npm_deploy, status: :ok}]},
    {:cypress, command: "mix cypress.run", deps: [{:phx_digest, status: :ok}]},
    {:npm_test, false},
    {:ex_coveralls,
     command: "mix coveralls.html",
     require_files: ["test/test_helper.exs"],
     env: %{"MIX_ENV" => "test"}},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, command: "mix test", env: %{"MIX_ENV" => "test"}}
  ]
]
