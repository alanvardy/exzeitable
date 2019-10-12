alias Exzeitable.Repo
alias TestWeb.{Post, User}

Repo.delete_all(User)
Repo.delete_all(Post)

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

# [
#   %Post{title: "Post number 1", content: "THIS IS CONTENT", user_id: 1},
#   %Post{title: "Post number 2", content: "THIS IS CONTENT", user_id: 2},
#   %Post{title: "Post number 3", content: "THIS IS CONTENT", user_id: 3},
#   %Post{title: "Post number 4", content: "THIS IS CONTENT", user_id: 4},
#   %Post{title: "Post number 5", content: "THIS IS CONTENT", user_id: 5},
#   %Post{title: "Post number 6", content: "THIS IS CONTENT", user_id: 6},
#   %Post{title: "Post number 7", content: "THIS IS CONTENT", user_id: 7}
# ]
# |> Enum.map(&Repo.insert/1)
