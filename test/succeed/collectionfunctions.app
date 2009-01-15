application test

section datamodel

  entity User{
    name     :: String
    parent -> User
    list -> List<User> (inverse=User.parent)
    set -> Set<User>
    
    function replaceList(l:List<User>){
      list := l;
    }
    function addL(u : User){
      list.add(u);
    }
    function insertL(i:Int,u : User){
      list.insert(i,u);
    }    
    
  }
  var u1:User := User{name := "bob" };
  var u2:User := User{name := "alice"};
  var u3:User := User{name := "charlie"};
  var u4:User := User{name := "dave"};
  
  define page home(){
    main()
    define body() {
      table{
      
        for(u:User){
          r{c{
            output(u.name)
            output(u.parent)
          }}
        }
      
        r{c{"name: " output(u1.name)}}
       
      
        r{c{"list: "}} 
        
        for(user:User in u1.list){
          r{c{
            output(user.name)
            form{action("remove",remove(u1,user))}
            form{action("make first",makeFirst(u1,user))}
          }}
        }
        r{c{"add to list: "}}
        for(user:User){
          r{c{
            output(user.name)
            form{action("add",add(u1,user))}
          }}
        }
        r{c{"second element: " output(u1.list.get(1))}}
        r{c{"location of Alice in list: " output(u1.list.indexOf(u2))}}
        form{
          r{c{"set: "  input(u1.set)}}     
          r{c{action("save",save(u1))}}
        }
      }
      r{c{
        form{
          action("list to set",l2s(u1))
          action("set to list",s2l(u1))
          action("clear list",cl(u1))
          action("clear set",cs(u1))
          action("replace list",replaceList(u1))
          var i: Int := 0;
          input(i)
          action("insert list",insertList(i,u1))

          //action("list to set",l2s(u1))
          //action("set to list",s2l(u1))
          //action("clear list",cl(u1))
          //action("clear set",cs(u1))
          action("replace list (entity function)",replaceListE(u1))
          var j: Int := 0;
          input(j)
          action("insert list (entity function)",insertListE(j,u1))
        }   
      }} 
    
    }
    action l2s(u:User){
      //var se : Set<User> := u.list.set();
      u.set := u.list.set();
      u.save();
      return home();
    }
    action s2l(u:User){
      //var li : List<User> := u.set.list();
      u.list := u.set.list();
      u.save();
      return home();
    }
    action cl(u:User){
      u.list.clear();
      u.save();
      return home();
    }
    action cs(u:User){
      u.set.clear();
      u.save();
      return home();
    }
    action save(u:User){
      u.save();
      return home();
    }
    action add(u:User,other:User){
      u.list.add(other);
      u.save();
      return home();
    }
    action remove(u:User,other:User){
      u.list.remove(other);
      u.save();
      return home();
    }
    action makeFirst(u:User,other:User){
      
      u.list.set(u.list.indexOf(other),u.list.get(0));
      u.list.set(0,other);
      
      u.save();
      return home();
    }   
    action replaceList(u:User){
      u.list := [u3,u4];
      u.save();
      return home();
    }   
    action insertList(i:Int,u:User){
      u.list.insert(i,u);
      u.save();
      return home();
    }

    action replaceListE(u:User){
      u.replaceList([u3,u4]);
      u.save();
      return home();
    }   
    action insertListE(i:Int,u:User){
      u.insertL(i,u);
      u.save();
      return home();
    }  

  }
  
  define main(){
    body()
  }
  
  define page user(u:User){
    derive viewPage from u
  }