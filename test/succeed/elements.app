application test

  entity User {
    username    :: String
  }
  
  var u1 := User{username :="Alice"}
  
  define page home(){
    navigate(user(u1)){"view user"}
  }
 
  define page user(u:User){
    for(i:Int from 1 to 10){
      hd{
        output(i) ":" output(u.username) "!"
      }
    }
  } 
  
  define hd(){
    <h3>
      elements
    </h3>
  }