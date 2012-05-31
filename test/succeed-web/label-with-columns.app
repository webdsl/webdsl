application label

  define page root(){
    var i := 0
    form{
      <table><tr>
        labelcolumns("input i: ")[class="inputlabel"]{
          input(i)[class="inputfield"]
        }
        labelcolumns("output i: "){
          output(i)
        }
      </tr></table>
      submit action{ Saveit{i:=i}.save(); } [class="savebutton"] { "save" }
    }
    <br />
    for(s:Saveit){
      "output:" output(s.i)
    }
  }
  
  entity Saveit{
    i :: Int
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));

    assert(d.getPageSource().split("<td>").length==5);
    var input := d.findElements(SelectBy.className("inputfield"))[0];
    var label := d.findElements(SelectBy.className("inputlabel"))[0];
    label.click();
    assert(label.getAttribute("for") == input.getAttribute("id"));
    input.sendKeys("123");
    var button := d.findElements(SelectBy.className("savebutton"))[0];
    button.click();
    assert(d.getPageSource().contains("output:123"));
  }
