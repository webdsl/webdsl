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
          menuitem{ navigate(user(u)) { "item1" } }
          menuspacer()
          menuitem{ navigate(user(u)) { "item2" } }
          
        }
      }
    }
  }
  
  define sitemenu2()
  {
    menubar("horizontal"){
      for(u:User)
      {
        menu
        {
          menuheader{ navigate(user(u)){output(u.username)} }
          menuitem{ navigate(user(u)) { "item1" } }
          menuspacer()
          menuitem{ navigate(user(u)) { "item2" } }
        }
      }
    }
  }

  define sitemenu3()
  {
    menubar("vertical"){
      for(u:User)
      {
        menu
        {
          menuheader{ navigate(user(u)){output(u.username)} }
          menuitem{ navigate(user(u)) { "item1" } }
          menuspacer()
          menuitem{ navigate(user(u)) { "item2" } }
        }
      }
    }
  }
  
  define page home(){
    sitemenu1()
    sitemenu2()
    sitemenu3()
    "home"
  }

  define page user(u:User)
  {
    sitemenu1()
    output(u.username)
  }