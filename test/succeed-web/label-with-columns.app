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
  
  test ajaxappendwithlist {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");

    assert(d.getPageSource().split("<td>").length==5);
    var input := d.findElements(SelectBy.className("inputfield"))[0];
    var label := d.findElements(SelectBy.className("inputlabel"))[0];
    label.click();
    assert(label.getAttribute("for") == input.getAttribute("id"));
    input.sendKeys("123");
    var button := d.findElements(SelectBy.className("savebutton"))[0];
    button.click();
    assert(d.getPageSource().contains("output:123"));
    
    d.close();
  }
