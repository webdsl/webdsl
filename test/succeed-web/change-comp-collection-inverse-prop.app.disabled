application exampleapp

//http://yellowgrass.org/issue/WebDSL/749

entity Container {
  name  :  String
  items <> List<Item>
}

entity Item {
  name : String
  container -> Container (inverse = Container.items)
}


var container1 : Container := Container{ name := "container one" }
var container2 : Container := Container{ name := "container two" }
var item1 : Item := Item{ name := "item one" }
var item2 : Item := Item{ name := "item two" }


define page root(){
   submit action{
   	container1.items.add(item1);
   	container1.items.add(item2);
   	return root2();
   }{ "add items" }
}

define page root2(){
   output(item1.container.name)
   submit action{
   	item1.container := container2;
   }{ "change container" }	
}

test mytest {
	var d : WebDriver := getFirefoxDriver();    
    var btn : WebElement;
    var pagesource : String;
    
    d.get(navigate(root()));
    btn:= d.findElement(SelectBy.className("button"));
    btn.click();    
    pagesource := d.getPageSource();    
    assert(pagesource.contains("container one"), "Container of `item one` should be `container one`");
    
    btn := d.findElement(SelectBy.className("button"));
    btn.click();
    pagesource := d.getPageSource();    
    assert(pagesource.contains("container two"), "Container of `item one` should now be `container two`");
}