application exampleapp
  
  entity IntHolder{
    i::Int
  }
  
  var e1 := IntHolder{i:=1}
  var e2 := IntHolder{i:=2}
  var e3 := IntHolder{i:=3}
  
  define page root(){
      //var i := 123
      form{
        //inp(i)
        inp(e1.i)//[class="in1"]
        inp(e2.i)//[class="in2"]
        inp(e3.i)//[class="in3"]
        submit action {} {"save"}
      }
      output(e1.i)
      output(e2.i)
      output(e3.i)
  }

  define inline /*@TODO make inlining automatic when it's reliable, inline modifier will force inlining*/ inp(i : Ref<Int>){
    //var tname := getTemplate().getUniqueId()
    //var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      //name=tname 
      name=getTemplate().getUniqueId() 
      if(getRequestParameter(getTemplate().getUniqueId()) != null){ 
        value = getRequestParameter(getTemplate().getUniqueId())//req 
      }
      else{
        value = i 
      }
      class="inputInt "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      log("id "+getTemplate().getUniqueId());
      log("db "+getRequestParameter(getTemplate().getUniqueId()));
      if(getRequestParameter(getTemplate().getUniqueId()) != null){
        i := getRequestParameter(getTemplate().getUniqueId()).parseInt();
      }
    }
  }

  define inline test(k:String){
    output(k)"abc"
  }
  
  
  test entityreftemplates {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
  
    var elems := d.findElements(SelectBy.tagName("input"));
    
    elems[1].sendKeys("1");
    elems[2].sendKeys("2");
    elems[3].sendKeys("3");
    elems[4].click();
    
    assert(d.getPageSource().contains("112233"));
    
    d.close();
  }

  //inline
  //current limitations:
  //no local redefine
  //no actions
  // no inlining in for loop (because of vars)
