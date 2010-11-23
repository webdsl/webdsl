//#30 Assignment to derived property is not allowed.

application test


  entity User{
    name :: String := "123" 
    foo :: String := "foo" 
    function a(){
      name := "23342";
      foo := "23342";
      this.name := "23342";
      this.foo := "23342";
    } 
  }
  var user := User {}
  var user2 := User {
    name := "23342"
    foo := "23342"
  }

  define page root()
  {
    init{
      user.name := "23342";
      user.foo := "23342";
    }
    action bla(){
      user.name := "23342";
      user.foo := "23342";
    }
    submit action{
      user.name := "23342";
      user.foo := "23342";
    } {"do it"}
  }

  function a(){
    user.name := "23342";
    user.foo := "23342";
  } 
  
  init{
    user.name := "23342";
    user.foo := "23342";
  }
  
  
  session bar{
    name :: String := "123" 
    foo :: String := "foo" 
    function a(){
      name := "23342";
      foo := "23342";
    } 
  }
  
  init{
    bar.name := "324234";
    bar.foo := "fdssfdsf";
  }
  
  
  entity UserSub:User{}
  
  var usersub := UserSub {}
  
   define page root2()
  {
    init{
      usersub.name := "23342";
      usersub.foo := "23342";
    }
    action bla(){
      usersub.name := "23342";
      usersub.foo := "23342";
    }
    submit action{
      usersub.name := "23342";
      usersub.foo := "23342";
    } {"do it"}
  }

  function a(){
    usersub.name := "23342";
    usersub.foo := "23342";
  } 
  
  init{
    usersub.name := "23342";
    usersub.foo := "23342";
  }
  
  
  