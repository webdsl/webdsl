//this wasn't working because of conflict with name property of securityContext, which is directly accessible in ac rules
//the arguments of the ac rule now take precedence over the securityContext properties

application test

  entity Page {
    name    :: String (id)
    content :: WikiText
  }
  
  define page page(name:String){ }

  define page root(){
   list{
        for(p : Page order by p.name asc) {
          listitem{
            navigate(page(p.name)){ output(p.name) }
          }
        }
      }
  }

  init{
    var p := Page{ name := "first page name!" content := "11" };
    p.save();
    var p := Page{ name := "second page name!" content := "22" };
    p.save();
  }

access control rules

  principal is Page with credentials name
  
  rule page page(name : String) {
    loggedIn() || (findPage(name) != null)
  }
  
  rule page root(){true}
  
section testing

  test {
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("first page name!"), "first page not shown");
    assert(d.getPageSource().contains("second page name!"), "second page not shown");
  }
  
  