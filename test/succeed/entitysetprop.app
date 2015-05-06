application test

section datamodel

  entity User{
    name     :: String
    children -> Set<User>
  }
  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  
  define page root(){
    
    "name: " output(u.name)
 /*   if(u.children != null)
    {
      "children: " output(u.children)
    }
   */ 
    form{
      input(u.name)
      input(u.children)
      action("save",save())
    }
     
    action save()
    {
      u.save();
    }    
  }

  entity Ent{
    a : String
    b : String
    c : String
    d : String
    order : String    
    extend function setA(s : String){ order := order + "a"; }
    extend function setB(s : String){ order := order + "b"; }
    extend function setC(s : String){ order := order + "c"; }
    extend function setD(s : String){ order := order + "d"; }
  } 

  test {
    var ent := Ent{ d := "" b := "" c := "" a := ""	};
    assert(ent.order == "dbca", "Entity properties are set in different order than declaration");
  }