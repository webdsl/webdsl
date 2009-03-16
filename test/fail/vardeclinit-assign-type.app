//is not of type Int

application test
  entity User{}
  function a(){
    var a :Int := "string";
    var a :Int := User{};
    
  }

  