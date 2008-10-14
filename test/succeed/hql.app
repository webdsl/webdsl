application test

section datamodel

  entity User{
    name :: String
    address :: String
  }
  
  define page home(){
    form{
      for(u1:User)
      {
        output(u1)
        output(u1.name)
        output(u1.address)
      }
    }
    "test page"
    var u : User := User{ name := "bob" address := "somewhere 1" };
    form{
      input(u.name)
      input(u.address)

      action("save",save())
    }

    action save() {
      u.save();
    }


  }


  define page user(u:User){

     var ps : List<User> :=
         select p from User as p
          where (~u = p);
     section{

       list{
         for(pers : User in ps) {
           listitem{ output(pers) }
         }
       }
     }


  }