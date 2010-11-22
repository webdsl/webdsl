//#8 Assignment to derived property is not allowed.

application test

  entity User{
    function a(){
      name := "23342";
      this.name := "23342";
    } 
  }
  var user := User {}
  var user2 := User {
    name := "23342"
  }

  define page root()
  {
    init{
      user.name := "23342";
    }
    action bla(){
      user.name := "23342";
    }
    submit action{
      user.name := "23342";
    } {"do it"}
  }

  function a(){
    user.name := "23342";
  } 
  
  init{
    user.name := "23342";
  }
  