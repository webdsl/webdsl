application test

section datamodel

  entity User{
    username :: String
  }

  var alice : User := User { username := "Alice" };
  var bob : User := User { username := "Bob" };
  var charlie : User := User { username := "Charlie" };
  var dave : User := User { username := "Dave" };
  
  define sitemenu1()
  {
    menubar{
      for(u:User)
      {
        menu
        {
          menuheader{ navigate(user(u)){output(u.username)} }
          menuitems{
            menuitem{ navigate(user(u)) { "item1" } }
            menuitem{ navigate(user(u)) { "item2" } }
          }
        }
      }
    }
  }

  define page root(){
    sitemenu1()
    "root"
  }

  define page user(u:User)
  {
    sitemenu1()
    output(u.username)
  }
