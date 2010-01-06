application test

entity Temp {
  val :: String
}

var globaltemp := Temp{val := "global Temp" }

define page root() {
  var i := globaltemp
  block[id:= hoi, onclick := actie()] { "hoi"} 
  action actie () {
    replace (hoi, template { 
      "hoi2"
      output(globaltemp.val)
      output(i.val)
      for(t:Temp){
        output(t.val)
      }
    }); 
  }
}
