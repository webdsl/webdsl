application test

  entity Ent {
    int :: Int
  }

  define page root() {
    var i := 0 	
    form{
      b()
      submit action{ Ent{  int := i }.save(); } {"save"}
    }
    for(e:Ent){
      output(e.int)
    }
    
    define b(){
      "correct" 
      input(i)
    }
    
    //define b() = root_b(*,i)
  }

  define b(){ "error" }

  test var {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected 3 <input> elements did not match");
    elist[1].sendKeys("23456789");
    elist[2].click();
    assert(d.getPageSource().contains("23456789"), "entered data not found");
    d.close();
  }
  

  
  /**
   *  Following fragments are not actively tested but caused compilation errors in previous versions of WebDSL
   */
  
  //triggered compilation error
  entity Page {}
  define localBody(){"default localBody"}
  define page bla(p:Page){
    define localBody(){
        navigate(bla(p)){"Full page"}
    }
  }
  
  
  //triggered compilation error
  define page editMenu(){
    var s := 34
    define localBody(){
     var e := Ent{int := s}
    }
  }
  
  
  //triggered compilation error
  define page communications(tab : String) {
    localBody()
    define localBody() {
      case(tab) {
        "inbox"   { "inbox" }
        "drafts"  { "drafts" }
      }
    }
  }
  
  
  //triggered compilation error
  entity Publication{
    cites -> Set<Publication>
  }
  define page referencesfrombibliography(pub : Publication) {
    define localBody() {
      action add(r:Publication) {
        pub.cites.add(r);
      }
      form{ action("Add as reference", add(pub)) }
    }
  }

  
  define body(){}


  //was not being inlined
  define page editinvitationtemplate() {
    define body() {
      form{
        submit action { } {"Save"}
      }
    }
  }
  
  
  //triggered compilation error
  define page confirmRegistration(/*conf : RegistrationEmailConfirmation*/) {
    var password : Secret
    define body() {
      form{ 
        input(password)
        action("Confirm", action{ 
        })
      }
    }
  }

