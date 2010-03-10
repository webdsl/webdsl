application test

section datamodel

  define body() {
    "default body"
  }

  entity User{
    name :: String
  }
  entity UserList{
    users -> List<User>
  }
  
  var u1:User := User{name := "bob" };
  var u2:User := User{name := "alice"};
  var u3:User := User{name := "charlie"};
  var u4:User := User{name := "dave"};
  
  var ulist := UserList{users := [u1,u2,u3,u4,u1,u1,u2]};
  
  define page root(){
    main()
    define body() {
      var i:Int := 0
      var ilist:List<Int> := [0,1,2,3,0,1,2,3]
      
      init{
        ilist.removeAt(5);
        ilist.remove(1);
      }
      action remove(user:User){
        ulist.users.remove(user);
        ulist.save();
      }
      action removeAt(index:Int){
        ulist.users.removeAt(index);
        ulist.save();
      }
      
      table{
        "users in list:"
        for(u:User in ulist.users){
          label("name: "){output(u.name)}
          form{action("remove",remove(u))}
          break
        }
        form{
          label("remove at"){input(i)}
          action("remove",removeAt(i))
        }
      }
      for(i:Int in ilist){
        output(i)
      }
      " == 023023"
    }
  }
      
  define main(){
    body()
  }
  
  define page user(u:User){
    derive viewPage from u
  }
