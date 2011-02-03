application datepicker

section pages
  
var d1:=DateTest{}
  
define page root(){
  navigate datepage() { " Date " }
  navigate datetimepage() { " DateTime " }
  navigate timepage() { " Time " }
  navigate alldatetypes(){" All "}
  
}  

entity DateTest {
  //implicit format
  date :: Date 
  
  usDotDate :: Date (format="MM.dd.yyyy")
  usDashDate :: Date (format="MM-dd-yyyy")
  usDate :: Date (format="MM/dd/yyyy")
  euDotDate :: Date (format="dd.MM.yyyy")
  euDashDate :: Date (format="dd-MM-yyyy")
  euDate :: Date (format="dd/MM/yyyy")
}
  
define page datepage() {
  div{
    form{
      div{ input(d1.date)[class="input1"] }  	

      div{ input(d1.usDotDate)[class="input2"] }
      div{ input(d1.usDashDate)[class="input3"] } 	
      div{ input(d1.usDate)[class="input4"] }
      div{ input(d1.euDotDate)[class="input5"] }
      div{ input(d1.euDashDate)[class="input6"] }  	
      div{ input(d1.euDate)[class="input7"] }
      
      div{ submit action{} { "Save" } }   	
    }
  }
  div{
    form{
      div{ input(d1.usDotDate)[format="dd/MM/yyyy", class="input8"] }
      div{ input(d1.usDashDate)[format="dd.MM.yyyy", class="input9"] } 	
      div{ input(d1.usDate)[format="dd-MM-yyyy", class="input10"] }
      div{ input(d1.euDotDate)[format="MM/dd/yyyy", class="input11"] }
      div{ input(d1.euDashDate)[format="MM.dd.yyyy", class="input12"] }  	
      div{ input(d1.euDate)[format="MM-dd-yyyy", class="input13"] }
      
      div{ submit action{} { "Save" } }   	
    }
  }
  div{ output(d1.date) }
  div{ output(d1.usDotDate) }
  div{ output(d1.usDashDate) }
  div{ output(d1.usDate) }
  div{ output(d1.euDotDate) }
  div{ output(d1.euDashDate) }
  div{ output(d1.euDate) }
  
}



/*
  test datetype {
    var d:WebDriver := FirefoxDriver();
    d.get(navigate(datepage()));
   
    d.findElement(SelectBy.className("dateinput1"));    
  }

*/



 entity DateTimeTest {
  date :: DateTime

  usDotDate :: DateTime (format="MM.dd.yyyy H:mm")
  usDashDate :: DateTime (format="MM-dd-yyyy H:mm")
  usDate :: DateTime (format="MM/dd/yyyy H:mm")
  euDotDate :: DateTime (format="dd.MM.yyyy H:mm")
  euDashDate :: DateTime (format="dd-MM-yyyy H:mm")
  euDate :: DateTime (format="dd/MM/yyyy H:mm")

}

var globaldt := DateTimeTest{}
  
  define page datetimepage() {
  div{
    form{
      div{ input(globaldt.date)[class="dateinput1"] }  	

      div{ input(globaldt.usDotDate)[class="input2"] }
      div{ input(globaldt.usDashDate)[class="input3"] } 	
      div{ input(globaldt.usDate)[class="input4"] }
      div{ input(globaldt.euDotDate)[class="input5"] }
      div{ input(globaldt.euDashDate)[class="input6"] }  	
      div{ input(globaldt.euDate)[class="input7"] }
     
      div{ submit action{} { "Save" } }   	
    }
  }
  div{
    form{
      
      div{ input(globaldt.usDotDate)[format="dd/MM/yyyy H:mm", class="input8"] }
      div{ input(globaldt.usDashDate)[format="dd.MM.yyyy H:mm", class="input9"] } 	
      div{ input(globaldt.usDate)[format="dd-MM-yyyy H:mm", class="input10"] }
      div{ input(globaldt.euDotDate)[format="MM/dd/yyyy H:mm", class="input11"] }
      div{ input(globaldt.euDashDate)[format="MM.dd.yyyy H:mm", class="input12"] }  	
      div{ input(globaldt.euDate)[format="MM-dd-yyyy H:mm", class="input13"] }
      
      div{ submit action{} { "Save" } }   	
    }
  }
  
  div{ output(globaldt.date) }
  div{ output(globaldt.usDotDate) }
  div{ output(globaldt.usDashDate) }
  div{ output(globaldt.usDate) }
  div{ output(globaldt.euDotDate) }
  div{ output(globaldt.euDashDate) }
  div{ output(globaldt.euDate) }
  
}

 entity TimeTest {
  time1 :: Time

  time2 :: Time (format="H/mm")
}

var globalt := TimeTest{}
  
  define page timepage() {
  div{
    form{
      div{ input(globalt.time1)[class="dateinput1"] }  	
      div{ input(globalt.time2)[class="dateinput2"] }  	
      div{ submit action{} { "Save" } }   	
    }
  }
  div{
    form{
      div{ input(globalt.time1)[format="H\\mm", class="dateinput3"] }
      div{ input(globalt.time2)[format="H.mm", class="dateinput3"] }
      
      div{ submit action{} { "Save" } }   	
    }
  }
  
  div{ output(globalt.time1) }
  div{ output(globalt.time2) }
}


entity AllDateTypes {
  d :: Date
  dt :: DateTime
  t :: Time
}
var globalall := AllDateTypes{}
define page alldatetypes(){
  form {
    input(globalall.d)
    input(globalall.dt)
    input(globalall.t)
    submit action{} { "save" }
  } 
  
  div{ output(globalall.d) }
  div{ output(globalall.dt) }
  div{ output(globalall.t) }
}