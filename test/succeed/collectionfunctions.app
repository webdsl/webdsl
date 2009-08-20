application test

section datamodel

  define body() {
    "default body"
  }

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
  
  define page root(){
    main()
    define body() {
      table{
      
        for(u:User){
          label("name: "){output(u.name)}
          label("parent: "){output(u.parent)}
          break
        }
      
        r{"details below for: " output(u1.name)}
       
        "list property: "
        for(user:User in u1.list){
          r{
            output(user.name)
            form{action("remove",remove(u1,user))}
            form{action("make first",makeFirst(u1,user))}
          }
        }
        form{action("removeFirst",removeAt(u1,0))}
        r{"add to list: "}
        for(user:User){
          r{
            output(user.name)
            form{action("add",add(u1,user))}
          }
        }
        r{"second element: " output(u1.list.get(1))}
        r{"location of Alice in list: " output(u1.list.indexOf(u2))}
        form{
          r{"set property: "  input(u1.set)}     
          r{action("save",save(u1))}
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
      return root();
    }
    action s2l(u:User){
      //var li : List<User> := u.set.list();
      u.list := u.set.list();
      u.save();
      return root();
    }
    action cl(u:User){
      u.list.clear();
      u.save();
      return root();
    }
    action cs(u:User){
      u.set.clear();
      u.save();
      return root();
    }
    action save(u:User){
      u.save();
      return root();
    }
    action add(u:User,other:User){
      u.list.add(other);
      u.save();
      return root();
    }
    action remove(u:User,other:User){
      u.list.remove(other);
      u.save();
      return root();
    }
    action removeAt(u:User,i:Int){
      u.list.removeAt(i);
      u.save();
      return root();
    }
    action makeFirst(u:User,other:User){
      
      u.list.set(u.list.indexOf(other),u.list.get(0));
      u.list.set(0,other);
      
      u.save();
      return root();
    }   
    action replaceList(u:User){
      u.list := [u3,u4];
      u.save();
      return root();
    }   
    action insertList(i:Int,u:User){
      u.list.insert(i,u);
      u.save();
      return root();
    }

    action replaceListE(u:User){
      u.replaceList([u3,u4]);
      u.save();
      return root();
    }   
    action insertListE(i:Int,u:User){
      u.insertL(i,u);
      u.save();
      return root();
    }  

  }
  
  define main(){
    body()
  }
  
  define page user(u:User){
    derive viewPage from u
  }
