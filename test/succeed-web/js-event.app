application test

  define page root() {
    var i := false
    form{
      input(i)[onchange:="javascript:"+"var div1 = document.getElementById('text1');if(div1.style.display == 'none'){div1.style.display = 'block';}else{div1.style.display = 'none'; }"]
    }
    <div id="text1" style="display:none;">
      "hidden text 1"
    </div>
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected 3 <input> elements did not match");
    elist[2].click();
    assert(d.getPageSource().contains("style=\"display: block;\""), "expected hidden text to have become visible");
  }
  
