//Inverse between lists not allowed

application test

  entity User{
    children -> List<User>
    parents -> List<User> (inverse=User.children)
  }
