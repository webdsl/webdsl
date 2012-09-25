//#3 Variable 'this' not defined
//#3 Variable 'super' not defined
application test

define page root() { 
	action save(){
		var x := this.id;
		var y := super.id;
	}
	var x := this.id
	var y := super.id
}

function test () {
	var x := this.id;
	var y := super.id;
}