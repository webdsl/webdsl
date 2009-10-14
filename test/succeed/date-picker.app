application datepicker

section pages

define page root() {
  navigate(datePicker(today(), 1)) { "Go to date picker" }
}

entity DateTest {
	usDate :: Date (format="mm/dd/yyyy")
	euDotDate :: Date (format="dd.mm.yyyy")
	euDashDate :: Date (format="dd-mm-yyyy")
	euDate :: Date (format="dd/mm/yyyy")
}

define page datePicker(date : Date, format : Int) {
	
	var dateTest := DateTest {};
	init {
		dateTest.usDate := date;
		dateTest.euDate := date;
		dateTest.euDotDate := date;
	}
	
	
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
		return datePicker(date, newFormat);		
	}
}
