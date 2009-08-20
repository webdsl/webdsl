application test

  entity User {
    username    :: String
  }
  
  var u1 := User{username :="Alice"}
  
  define page root(){
    for(u:User){
      output(u.username) " "
    }
  
    navigate(user(u1)){"view user"}
    navigate(createUser()){"create user"}
  }
 
  define page user(u:User){
    action test(j:Int){
      var uzer := User{username:=j.toString()};
      uzer.save();
      return root();  
    }
    for(i:Int from 1 to 10){
      hd{
        output(i) ":" output(u.username) "!"
        form{action("test",test(i))}
      }
    }
    
  } 
  
  define body(){}
  
  define page createUser(){
    var u := User{username := "user"}

    hd{
      form{
        "New User: "
        input(u.username)
        action("save", save())
      }
    }
   
    action save(){
      u.save();
      return root();
    }      

    body()
    define body(){
      hd{"out" output(u.username)}
    } 
  }
  
  define hd(){
    <h3>
      elements
    </h3>
  }
