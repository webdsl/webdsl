application exampleapp

  page root(){
    var i := 1
    var j := 2
    form{
      labelcolumns("mylabel") {
        input(i)[class="firstinput"]
      }
      label("thelabel"){
        input(j)[class="secondinput"]
      }
      submit action{} [class="savebtn"] {"submit"}
    }
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    d.findElement(SelectBy.className("firstinput")).sendKeys("foo");
    d.findElement(SelectBy.className("secondinput")).sendKeys("foo");
    d.findElement(SelectBy.className("savebtn")).click();
    assert(d.getPageSource().split("Not a valid number").length == 3);
  }