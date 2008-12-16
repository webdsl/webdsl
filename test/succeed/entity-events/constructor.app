application constructor

  entity User {
    name :: String
    page -> UserPage
  }
  
  entity UserPage {
    user -> User
    page -> Page
    message :: String
    name :: String := "User: " + user.name + " Page: " + page.name 
  }
  
  entity Page {
    name :: String
    content :: WikiText
  }
  
  extend entity User{
    extend function User(){
      this.page := UserPage{ user := this page := p1 message := "default message" };
      this.page.save();
    }
  }
  
  // test both global vars and init, handled differently in back-end
  var u1 := User{ name := "Alice" };
  init{
    var u2 := User{ name := "Bob" };
    u2.save();
  }
    
  var p1 := Page { name := "p1" content := "This is page 1." };
  var p2 := Page { name := "p2" content := "This is page 2." };
  

  
  define page home(){
    for(u:User){
      group(u.name){
        showPage(u.page)
        
        form{
          input(u.name)
          input(u.page.page)
          input(u.page.message)
          action("save",save(u))
          action save(u:User){
            u.save();
            return home();
          }
        }
      }
      
    }  
  }
  
  define showPage(p:UserPage){
    group(p.name){
      groupitem{output(p.page.content)}
      groupitem{output(p.message)}
    }
  }