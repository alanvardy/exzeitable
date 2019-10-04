alias PhoenixWeb.{Repo, User}

Repo.delete_all(User)

[
  %User{name: "Bob", age: 40},
  %User{name: "Suzy", age: 50},
  %User{name: "Jeff", age: 72},
  %User{name: "Alan", age: 25},
  %User{name: "Mark", age: 10},
  %User{name: "Nancy", age: 80},
  %User{name: "Sioban", age: 21}
]
|> Enum.map(&Repo.insert/1)
