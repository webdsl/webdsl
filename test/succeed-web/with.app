application test

  entity User{
    name :: String
  }
  
  define page root(){
    test() with {
      content(s:String){ "123" output(s) }
    }
    
    break
    
    test2()
  }

  define test() requires content(String){
    "content: " content("456")
  }

  define test2() {
    validationContextTest with{
      error(messages : List<String>) { errorMessageTest(messages)/*{ "length:" output(messages.length) elements() } */}
      content() { "content" }
    }
  }
   
  define errorMessageTest(messages : List<String>){
    <h1>
      for(m: String in messages){
        output(m)
      }
      //elements()
    </h1>
  }
   
  define validationContextTest() requires error(List<String>), content(){
    error(["abc","def","ghi"])/* @TODO]] {
      content()
    }*/
  }
  
  test pagecontent{
    var d := HtmlUnitDriver();
    d.get(navigate(root()));
    log(d.getPageSource());
    assert(d.getPageSource().contains("content: 123456"));
    assert(d.getPageSource().contains("abcdefghi"));
    
    d.close();
  }