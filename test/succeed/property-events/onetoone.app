application test

section datamodel

  define override body() {
    "default body"
  }

  entity User{
    name :: String
    //children -> Set<User>
    relation -> User
  }
  
  extend entity User{
    extend function setRelation(user:User) {
      if(relation != null) {
        relation.relation := null;
      }
      if(user != null) {
        user.relation := this;
      }
    }   
    extend function setName(new:String) {
      name := new + "bla";
    }
  }

  define override main() 
  {
    body()
  }

  var u:User := User{name := "Alice"};
  var u1:User := User{name := "Bob"};
  var u2:User := User{name := "Charlie"};
  var u3:User := User{name := "Dave"};
  
  define page user(user:User){
    derive viewPage from user
  }
    
  define page root(){
    main()
   
    define body()
    { 
      action save(user:User){
        user.save();
        return root();
      } 

      "  -  "
      for(user:User){
        output(user.name)" "
        output(user.relation)"  -  "
        //output(user.children)
      }
      
      for(user:User){
        form{
          input(user.name)
          input(user.relation)
          //input(user.children)
          action("save",save(user))
        }
      }
    }
  }
