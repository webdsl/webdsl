application test

  define page root() {
    var i := ""
    placeholder tmp test(getString())
    form{
      input(i)[class="the-input"]
      submit action{ replace(tmp,test(i));} [ajax, class="button-1"] {"replace-root"}
    }
  }

  define ajax test(a:String){
    <div class="the-output">output("the string: " + a)</div>
    form{
      submit action{ replace(tmp,test(a));} [class="button-2"] {"replace-ajax-template"}
    }
  }


  test{
    var d := getFirefoxDriver();
    d.get(navigate(root()));
    checkit(d);

    d.findElement(SelectBy.className("button-2")).click();
    checkit(d);

    d.findElement(SelectBy.className("the-input")).sendKeys(getString());
    d.findElement(SelectBy.className("button-1")).click();
    checkit(d);

    d.findElement(SelectBy.className("button-2")).click();
    checkit(d);
  }

function checkit(d : WebDriver){
 assert( d.findElement(SelectBy.className("the-output")).getText().contains( "the string: " +  getString() ) );
}

function getString() : String{
    return "\\\"|\\'\\'>\\\\\\<><>?/,,./\"\"\"'./ '\"'\"```~ ~~~`&quot;&amp;";
}

