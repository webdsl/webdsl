application test

section datamodel
  
  define body() {
    "default body"
  }
  
  entity User{
    name :: String
    children -> Set<User>
    parents -> Set<User>
  }
  
  extend entity User{
    extend function addToChildren(u:User) {
      u.parents.add(this);
    }   
    extend function removeFromChildren(u:User) {
      u.parents.remove(this);
    }
  }
  
  extend entity User{
    extend function addToParents(u:User) {
      u.children.add(this);
    }   
    extend function removeFromParents(u:User) {
      u.children.remove(this);
    }
  }

  define main() 
  {
    body()
  }
  
  init{

  var u:User := User{name := "Alice"};
  var u1:User := User{name := "Bob"};
  var u2:User := User{name := "Charlie"};
  var u3:User := User{name := "Dave"};
  
  u.save();
  u1.save();
  u2.save();
  u3.save();
  }
  
  define page user(u:User){
    derive viewPage from u
  }
    
  define page root(){
    main()
   
    define body()
    { 
      table{row{
      for(user:User){
          c{"-----"}
          c{
            c{output(user.name)" "}
            c{
              " parent: "
              output(user.parents)

            }
            c{
              " children: "output(user.children)
              for(child : User){
                output(child.name)
                if(child in user.children){
                  form {
                    action("remove child",removeChild(user,child))
                  }
                  action removeChild(parent:User,child:User){
                    parent.children.remove(child);
                    parent.save();
                    return root();
                  }
                }
                if(!(child in user.children)){
                  form {
                    action("add child",addChild(user,child))
                  }
                  action addChild(parent:User,child:User){
                    parent.children.add(child);
                    parent.save();
                    return root();
                  }                
                }
              }
            }
            
          }
        
      }}
      }
      
      for(user:User){
        form{
          input(user.name)
          "parents"
          input(user.parents)
          action("save",save(user))
        }
        form{
          "children"
          input(user.children)
          action("save",save(user))
        }

        action save(user:User){
          user.save();
          return root();
        } 
      }
    }
  }