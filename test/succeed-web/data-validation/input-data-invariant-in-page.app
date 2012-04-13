application inputint

  entity Y {
    i :: Int
    y -> Y
    yset -> Set<Y>
    validate(i > 6, "number must be greater than 6")
    validate(y != this, "cannot choose self as y")
    validate(!(this in yset), "cannot choose self in list")
  }

  var y  := Y{ i := 8}
  var y0  := Y{ i := 8}
  var y1  := Y{ i := 8}

  define page root(){
    form{
      input(y.i){
        validate(y.i > 5, "number must be greater than 5")
        //validategeni(y)
      }
      input(y.y,[y,y0,y1])
      select(y.yset, [y,y0,y1])
      submit action{} {"save"}
    }

    for(bla: Y){
      output(bla.i)
    } separated-by{ <br/> }
  }
 /*
  define validategeni(ent:Y){
    var validations := ent.validateI();
    for(val: ValidationException in validations.exceptions){
      validate(false,val.message)
    }
  }
 */

  test datavalidation {
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(root()));

    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 5, "expected 5 <input> elements");

    elist[1].clear();
    elist[1].sendKeys("5");

    var slist : List<WebElement> := d.findElements(SelectBy.tagName("option"));
    assert(slist.length == 7, "expected 7 <option> elements"); //4 for input(y.y) which includes the empty selection 3 for input(y.ylist)

    slist[1].click();
    slist[4].click();

    elist[4].click();

    var pagesource := d.getPageSource();

    assert(pagesource.contains("number must be greater than 6"));
    assert(pagesource.contains("cannot choose self as y"));
    assert(pagesource.contains("cannot choose self in list"));
    assert(pagesource.contains("number must be greater than 5"));
  }
