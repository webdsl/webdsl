application test

  define page root(){
    mytemplate[title="title12345",style="foobar"]
  }

  template mytemplate(){
    mytemplatefinal[all attributes]
    mytemplatefinal[all attributes except "title"]
    mytemplatefinal[all attributes except ["title"]]
    mytemplatefinal[attributes ["title"]]
    mytemplatefinal[attributes "title"]
  }

  template mytemplatefinal(){
    <div class="testdiv" all attributes></div>
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.className("testdiv"));
    assert(elist.length == 5, "expected 5 <div> elements");
    assert(d.getPageSource().split("title12345").length==4);
    assert(d.getPageSource().split("foobar").length==4);
  }
