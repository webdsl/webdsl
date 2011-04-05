application datetime_extensive

description {
  Extensive Date Picker Tester
}

section pages

define page root() {
  main()
  define body() {
    "Hello world!"
  }
}

entity DateTest {
  usDate :: Date (format="mm/dd/yyyy")
  euDotDate :: Date (format="dd.mm.yyyy")
  euDashDate :: Date (format="dd-mm-yyyy")
  euDate :: Date (format="dd/mm/yyyy")
}

entity DateTimeTest {
  usDate :: DateTime (format="mm/dd/yyyy")
  euDotDate :: DateTime (format="dd.mm.yyyy")
  euDashDate :: DateTime (format="dd-mm-yyyy")
  euDate :: DateTime (format="dd/mm/yyyy")
}

define page testParamPage(test : DateTest) {

}
entity Foo { t :: Time }
var gFoo := Foo{}
define page testTimePicker() {
  main()

  define body() {
  
    form {
      input(gFoo.t)
      
      spacer
      
      "You have selected:"
      break
      output(gFoo.t)
      break
      
      spacer
      
      action("Save", save())
    }
    
    action save() {
      return testTimePicker();		
    }
  }

}

var dateTest := DateTest{};

define page testDatePicker(format : Int) {
  var date : Date := today();
  main()
  
  define body() {
  
    form {
    
      case (format) {
        1 {
          "Europe Input"
          input(date)[format:="dd/mm/yyyy"]
        }
        2 {
          "Europe Dot Input"
          input(date)[format:="dd.mm.yyyy"]
        }
        3 {
          "Europe Dash Input"
          input(date)[format:="dd-mm-yyyy"]
        }
        100 {
          "American Input"
          input(date)[format:="mm/dd/yyyy"]
        }
        101 {
          "American Dash Input"
          input(date)[format:="mm-dd-yyyy"]
        }
        default {
          "Invalid format..."
        }
      }
      
      spacer
      
      "Date (European)"
      break
      output(dateTest.euDate)
      break
      
      "Date (European Dot)"
      break
      output(dateTest.euDotDate)
      break
      
      "Date (European Dash)"
      break
      output(dateTest.euDashDate)
      break
      
      "Date (American)"
      break
      output(dateTest.usDate)
      break
      
      spacer
      
      action("Save, enter Europe style", save(1))
      break
      action("Save, enter Europe Dot style", save(2))
      break
      action("Save, enter Europe Dash style", save(3))
      break
      action("Save, enter American style", save(100))
      break
      action("Save, enter American style", save(101))
    }
    action save(newFormat : Int) {
      dateTest.usDate := date;
      dateTest.euDate := date;
      dateTest.euDotDate := date;
      dateTest.euDashDate := date;
      return testDatePicker(newFormat);		
    }
  }
  
}

var dateTimeTest := DateTimeTest{}

define page testDateTimePicker(format : Int) {
  var date : DateTime := now()
  
  main()
  
  define body() {
  
    form {
    
      case (format) {
        1 {
          "Europe Input"
          input(date)[format:="dd/mm/yyyy"]
        }
        2 {
          "Europe Dot Input"
          input(date)[format:="dd.mm.yyyy"]
        }
        3 {
          "Europe Dash Input"
          input(date)[format:="dd-mm-yyyy"]
        }
        100 {
          "American Input"
          input(date)[format:="mm/dd/yyyy"]
        }
        default {
          "Invalid format..."
        }
      }
      
      spacer
      
      "Date (European)"
      break
      output(dateTest.euDate)
      break
      
      "Date (European Dot)"
      break
      output(dateTest.euDotDate)
      break
      
      "Date (European Dash)"
      break
      output(dateTest.euDashDate)
      break
      
      "Date (American)"
      break
      output(dateTest.usDate)
      break
      
      spacer
      
      action("Save, enter Europe style", save(1))
      break
      action("Save, enter Europe Dot style", save(2))
      break
      action("Save, enter Europe Dash style", save(3))
      break
      action("Save, enter American style", save(100))
    }
    action save(newFormat : Int) {
      dateTimeTest.usDate := date;
      dateTimeTest.euDate := date;
      dateTimeTest.euDotDate := date;
      dateTimeTest.euDashDate := date;
      return testDateTimePicker(newFormat);		
    }
  }
  
}


// ---------------------- templates


define main() {
  <div id="pagewrapper">
     <div id="header">
        mainheader()
     </div>
     <div id="navbar">
       applicationmenu()
     </div>
     <div id="content">
       body()
     </div>
     <div id="footer">
       <p />"powered by " <a href="http://webdsl.org">"WebDSL"</a><p />
     </div>
  </div>
}

define body(){
  "default body"
}

define mainheader() {
  navigate(root()){
    image("/images/logosmall.png")
  }
}

define applicationmenu() {
  <ul>
    <li>navigate(root()){"Home"}</li>
    <li>navigate(testDatePicker(1)){ "Test Date Picker" }</li>
    <li>navigate(testTimePicker()){ "Test Time Picker" }</li>
    <li>navigate(testDateTimePicker(1)){ "Test DateTime Picker" }</li>
  </ul>
}
 
define override ignore-access-control errorTemplateInput(messages : List<String>){
  elements()
  for(ve: String in messages){
    <tr style="color: #FF0000;border: 1px solid #FF0000;">
      <td></td>
      <td>
        output(ve)
      </td>
    </tr>
  }
}

