// need something to declare that one template has to use the checks of another template, so the ac rules can
// easily be copied when lifting local template definitions

application test

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
  
    rule template bar(i:Int){
      i >5 
      rule action save(*){
        i >5
      }
    }

  rule page root(){true}      
  
section somesection  
  
  define foo(u:User, i : Int){

    apply ac rules bar(i)

    submit save("dfgdfg",User{}){"save"}
    action save(s:String, u2:User){
      var test := "" + (s.length() + i) + (u == u2);
      User{name := test}.save();
    }
  } 

  define bar(i:Int){
    foo(User{},i)
  }
  
  define page root(){
    bar(6)
    
    for(u:User){
      output(u.name)
    }
  }
  
  test {
    var d : WebDriver := getHtmlUnitDriver();
    
    d.get(navigate(root()));

    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected 1 <input> elements did not match");
    elist[0].click();
  }
  

  //caused java compilation error
  entity Publication{}
  entity AbstractAuthor{}
  define identifyPersonAction(first : String, initials : String, last : String, affil : String, home : URL) {}
  define addAuthorForPublication(pub : Publication, author : AbstractAuthor) {
    define identifyPersonAction(first : String, initials : String, last : String, affil : String, home : URL) {
      action addAuthor() {
      }
      action("Add", addAuthor())
    }
  }
  access control rules 
    rule template addAuthorForPublication(pub : Publication, author : AbstractAuthor){
      pub.name != author.name
      rule action addAuthor(){
        pub.name != author.name
      }
    }
    rule template addAuthorForPublication(pub : Publication, author : AbstractAuthor){
      true
      rule action addAuthor(){
        true
      }
    }

