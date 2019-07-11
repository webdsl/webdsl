application exampleapp

entity Person {
  name :: String
  ident :: String (id/*, validate(isUniquePerson(this),"id not unique")*/)
}

var p1 := Person{ name := "example person 1" ident:="1" }
var p2 := Person{ name := "example person 2" ident:="2" }

entity Person1 {
  name :: String
  ident :: String (id, iderror="name taken!", idemptyerror="name missing!")
}

var p11 := Person1{ name := "example person 1" ident:="1" }
var p12 := Person1{ name := "example person 2" ident:="2" }

define page root(){
  for(p:Person order by p.name){
    form{
  	  input(p.ident)[class="input"]
  	  submit action{} [class="button"] {"save"}
    }
  }    
}

test headless{
	p1.ident := "2";
	var errors := p1.validateSave().exceptions;
	assert(errors.length==1);
	assert(errors[0].message == "Identity '2' is already used.");

	p11.ident := "2";
	var errors1 := p11.validateSave().exceptions;
	assert(errors1.length==1);
	assert(errors1[0].message == "name taken!");

	p1.ident := "";
	var errors2 := p1.validateSave().exceptions;
	assert(errors2.length==1);
	assert(errors2[0].message == "Identity may not be empty.");

	p11.ident := "";
	var errors3 := p11.validateSave().exceptions;
	assert(errors3.length==1);
	assert(errors3[0].message == "name missing!");
}

