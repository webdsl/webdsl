application exampleapp

define page root(){
    var i := 1
    var j := 2
    form{
      labelcolumns("mylabel") {
        input(i)
      }
      label("thelabel"){
        input(j)
      }
      submit action{} {"submit"}
    }
}


test {
	assert(false,  "NO TESTS AVAILABLE");
}