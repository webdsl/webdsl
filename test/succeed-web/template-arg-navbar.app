application navbartest

template main(){
  head{
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no"/>
    <title>"navbar test"</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.0/css/materialize.min.css">
  }

  elements 

  <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.0/js/materialize.min.js"></script>
}

page root(){
  main{
    navigate view("1") {"go"} 
  }
}

page view(tab: String){
  main{
    testtemplate(tab)
  }
}

template testtemplate(tab: String){
  var testint := 1
  navbar(
    "Logo",
    tab,
    [
      ( "1",
        { navigate view("1"){ "one" } },
        { "elems1" "" }
      ),
      ( "2",
        { navigate view("2"){ "two" } },
        { "elems2" "" }
      ),
      ( "3",
        { navigate view("3"){ "three" } },
        { "elems3" "" }
      ),
      for(i: Int from 4 to 6){
      	( i.toString(),
          { navigate view(""+i){ "link" output(i) } },
          { "elems" output(i)
            form{
              input(testint)[class="testinput"]
              submit action{ Tmp{ i := testint }.save(); } {"save"}
            }
            "output:" if((from Tmp).length > 0){ output((from Tmp)[0].i) }
          }
        )
      }
    ]
  )
}

entity Tmp{
  i: Int
}

template navbar(logo: String, selected: String, contents: [title: String, nav: TemplateElements, elems: TemplateElements]){
  <nav>
    <div class="nav-wrapper">
      <ul id="nav-mobile" class="right hide-on-med-and-down">
        for(c in contents){
          if(c.title == selected){
            <li class="active">
              c.nav
            </li>	
          }
          else{
          	<li>
              c.nav
            </li>
          }
        }
      </ul>
    </div>
  </nav>
  for(c in contents){
    if(c.title == selected){
      body{
        c.elems
      }
    }
  }
}

template body(){ div{ elements } }

test {
  var d : WebDriver := getHtmlUnitDriver();
  d.get(navigate(root()));
  d.findElement(SelectBy.tagName("a")).click();
  assert(d.getPageSource().contains("elems1"));
  for(i:Int from 0 to 5){
  	testhelper(d, i);
  }
  d.findElement(SelectBy.className("testinput")).sendKeys("4231");
  d.getSubmit().click();
  assert(d.getPageSource().contains("output:14231"));
}
  
function testhelper(d: WebDriver, i: Int){
  d.findElements(SelectBy.tagName("a"))[i].click();
  assert(d.getPageSource().contains("elems"+(i+1)));
}
  