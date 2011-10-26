application withtest4

  define page root() {
     var s := "2"
     var i := 5
     var s6 := "6"
     var s7 := "7"
     helloowner(s6,s7) with {
       hello(s2:Ref<String>, s3:Ref<String>) { 
         output(s) input(s2)[class:="input1"] input(s3)[class:="input2"] output(i)
       } 
     }
     output(result.s)
  }   
  
  entity Result { s::String}
  var result := Result{}
      
  define template helloowner(s1:Ref<String>, s2:Ref<String>) requires hello(Ref<String>,Ref<String>) {
    var s3 := "3"
    var s4 := "4"
    
    form{
      hello(s3, s4) output(s1) output(s2)
      submit action{ result.s := "s3:"+s3+",s4:"+s4; } [class:="savebutton"]{"save"} 
    }
  } 
  
  test {
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    var input1 := d.findElements(SelectBy.className("input1"))[0];
    var input2 := d.findElements(SelectBy.className("input2"))[0];
    input1.sendKeys("numberone");
    input2.sendKeys("numbertwo");
    var button := d.findElements(SelectBy.className("savebutton"))[0];
    button.click();
    assert(d.getPageSource().contains("s3:3numberone,s4:4numbertwo"));
  }
