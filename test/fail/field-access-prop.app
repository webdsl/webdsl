//No property naml defined for User

application test
  entity User{
    name :: String
  }
  function a(u:User){
    u.naml;
    //var s:String := u.naml;
  }

  