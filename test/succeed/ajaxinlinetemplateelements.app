application test

entity Temp {
  val :: String
}

var globaltemp := Temp{val := "global Temp" }

define page root() {
  var i := globaltemp
  placeholder testph {}
  test(){ "elements call" output(i.val) }
  
}

define test(){
  block[ onclick := actie()] { "clickme"} 
  
  action actie () {
    replace (testph, template { 
      elements
    }); 
  }
}