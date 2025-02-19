application test

  entity One {
    prop :: String(id)
  }

  entity Two {
    prop :: Int
  }

  define page root(){
    "root page"
    form{
      
      "1: A single quote `'` should not get escaped in json "
      
      submit("ajaxsave2", 
        action{ var one := One{prop:="1111"+random()}; 
        one.save();
        var two:=Two{prop :=234234}; 
        two.save();
        replace(pl, atemp(one,two,"dsfdsssf",34345)); 
        }
      )[ajax]
        
    }
    
    placeholder pl { "2: A single quote `'` should not get escaped in json " }
    
    overrideAjaxJsClientExecute
  }
  
  template overrideAjaxJsClientExecute(){
    var tryParse := "try { JSON.parse(jsoncode); } catch (e) { reportJSONFailed() }"
    <script>
      const originalClientExecute = window.clientExecute;
      window.clientExecute = function(jsoncode, thisobject) {
          // Validate JSON using JSON.parse
          ~tryParse
          //JSON.parse is less strict than JSON spec, which does not allow single quotes to be escaped
          //We also want the json code to not escape forward slashes
          if(/(\\')|(\\\/)/.test(jsoncode)){
            reportJSONFailed();
          }
          
          
          // Call the original function
          return originalClientExecute(jsoncode, thisobject);
      }
      function reportJSONFailed(){
          document.body.insertAdjacentHTML('beforeend', "invalid " + "json " + "received");
      }

    </script>
  }
  
  define ajax atemp(one : One, two: Two, foo:String, bar:Int){
    var s : String := foo
    var i : Int := bar
    "ajax template"
    "3: A single quote `'` should not get escaped in json "
    form{
      input(one.prop)
      input(two.prop)
      input(s)
      input(i)
      submit("save",action{refresh();})[ajax]
      "4: A single quote `'` should not get escaped in json "
    }
    
    includeJS("http://localhost/resource.js")
    includeCSS("http://localhost/resource.css")
    submit("action with validation error",action{ validate(false, "VALIDATION ERROR"); refresh();})[ajax]
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("ajax template"), "expected to see ajax template");
    //check for dynamically loaded resources
    assert(d.getPageSource().contains("localhost/resource.js"), "expected to see js resource injected");
    assert(d.getPageSource().contains("localhost/resource.css"), "expected to see css resource injected");
  
    checkForJSONParseFailure(d);
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==10, "incorrect number of input elements found");
    log(d.getPageSource());
    d.getSubmits()[1].click();
    
    checkForJSONParseFailure(d);
    log(d.getPageSource());
    assert(!(d.getPageSource().contains("ajax template")), "expected ajax template to be removed here");
    
    
    //now click button outside form
    d.getSubmit().click();
    checkForJSONParseFailure(d);
    
    assert(d.getPageSource().contains("ajax template"), "expected to see ajax template");
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist1.length == 10, "incorrect number of input elements found");
    log(d.getPageSource());
    d.getSubmits()[2].click();
    checkForJSONParseFailure(d);
    
    assert( d.getPageSource().contains("ajax template") && d.getPageSource().contains("VALIDATION ERROR"), "expected validation error");
  }
  
  function checkForJSONParseFailure(d : WebDriver){
    assert( !d.getPageSource().contains("invalid json received"), "Malformed json received" );
  }
   