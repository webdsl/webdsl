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
  
  test{
    var s := "Bob";
    var u2 := (from User as u where u.name = ~s)[0];
    assert(u1.page.message == "default message");
    assert(u2.page.message == "default message");
    assert(u1.page != u2.page);
  }
    
  var p1 := Page { name := "p1" content := "This is page 1." };
  var p2 := Page { name := "p2" content := "This is page 2." };
  
  define page root(){
    action save(u:User){
      u.save();
      return root();
    }
    for(u:User){
      group(u.name){
        showPage(u.page)
        
        form{
          input(u.name)
          input(u.page.page)
          input(u.page.message)
          action("save",save(u))
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


  entity Aa{
    i : Int
    extend function Aa(){
      i := 12;
    }
  }
  entity Bb : Aa{
    s : String
    extend function Bb(){
      s := "34";
    }
  }
  test{
    assert(Bb{}.s+Bb{}.i == "3412");
  }
  
  entity A1{
    i : Int
    extend function A1(){
      i := 12;
    }
  }
  entity B1: A1{
    s : String
  }
  test{
    assert(B1{}.s+B1{}.i == "12");
  }
  
  