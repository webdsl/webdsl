/**
 *  Test input without label
 *
 */

application input

  entity User {
    name :: String (validate(name.length() > 2,"Name should be longer than 2 characters."))
    age :: Int (validate(age >= 0,"Age cannot be a negative number."))
    bool :: Bool
    float :: Float
    text :: Text
    wiki :: WikiText
    secret :: Secret
  }
  
  define page root() {
    title{"root"}
    
    var u := User { name := "bob" }
    form {
      input(u.name)" "
      ageinput(u)
      input(u.bool)" "
      input(u.float)" "
      input(u.text)" "
      input(u.wiki)" "
      input(u.secret)" "
      
      action("save",save())
    }
    action save(){
      u.save();
      return viewUser(u);
    }
    for(user:User){
      navigate(viewUser(user)){output(user.name)}
    }
  }
  
  define page viewUser(us:User){
      title{output(us.name)}
      
      output(us.age)" "
      output(us.bool)" "
      output(us.float)" "
      output(us.text)" "
      output(us.wiki)" "
      output(us.secret)" "
  }

  define ageinput(user:User) {
    input(user.age)" "
  }
  
  test inputvalidate {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");

    var elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 8, "expected 8 <input> elements");
    
    elist[1].clear();
    elist[1].sendKeys("t");
    elist[7].click();
    
    assert(d.getPageSource().contains("Name should be longer than 2 characters."), "didn't find validation message for name property");

    elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 8, "expected 8 <input> elements");
    elist[1].sendKeys("tdsfsdfds");
    elist[2].clear();
    elist[2].sendKeys("-12");
    elist[7].click();
   
    assert(d.getPageSource().contains("Age cannot be a negative number."), "didn't find validation message for age property");
    
    elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 8, "expected 8 <input> elements");
    elist[2].clear();
    elist[2].sendKeys("6");
    elist[5].sendKeys("fseg5rtyhfgn5");
    elist[7].click();
    
    assert(d.getPageSource().contains("valid decimal number"), "didn't find validation message for age property");
    
    elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 8, "expected 8 <input> elements");
    elist[5].clear();
    elist[5].sendKeys("0.0");
    elist[7].click();
   
    assert(d.getTitle() == "ttdsfsdfds", "action didn't complete correctly, redirect was not performed or name value is wrong");
   
    d.close();
  }
