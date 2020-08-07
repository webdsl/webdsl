application test

section datamodel

  define override body() {
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
      for(i1:Int in ilist){
        output(i1)
      }
      " == 023023"
    }
  }
      
  define override main(){
    body()
  }
  
  define page user(u:User){
    derive viewPage from u
  }
  
  
  test remove{
  	var initialList := [u1,u2,u3,u4,u1,u1,u2,u1];
  	var len := initialList.length;
  	var ul := UserList{users := initialList};
  	ul.save();
  	
  	assert(ul.users.length == len);

  	ul.users.insert(0, null as User); // adding null is not supported
  	ul.users.insert(5, null as User); 
  	assert(ul.users.length == len);
  	
  	assert(ul.users.indexOf(u4) == 3);

  	ul.users.remove(u4);
  	len := len - 1;
  	assert(ul.users.length == len);

  	ul.users.remove(u2); // this removes a single instance of both u2's in list
  	len := len - 1;
  	assert(ul.users.length == len);
  	ul.users.remove(u2);
  	len := len - 1;
  	assert(ul.users.length == len);

  	var copy := [u | u in ul.users];
  	ul.users.clear();
  	len := 0;
  	assert(ul.users.length == len);
  	
  	len := copy.length;
  	ul.users := copy;
  	assert(ul.users.length == len);
  	
  	ul.users := [u1, u2, u3, u4];
  	len := 4;
  	assert(ul.users.length == len);
  	
  }

