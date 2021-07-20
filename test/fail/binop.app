//#10 Wrong operand types for operator
//#2 Type of expression being assigned 'Double' is incompatible with type in left-hand side 'Float'
application binop

page root(){}

entity Ent1 : Ent2 {}	
entity Ent2 : Ent3 {}
entity Ent3 {}
 
function testbinop(sarg:String) {
    1+1;  
    1.0+1.0;
    "123"+123;
    "123"+"123";
    "123"+1.2;
    1+"123";
    Ent1{}+Ent1{}; // error
    var x1 := Ent1{}+Ent1{}; // error
    var x2 := Ent1{} > Ent1{}; // error
	  var x3 := Ent1{} >= Ent1{}; // error
	  var x4 := Ent1{} < Ent1{}; // error
	  var x5 := Ent1{} <= Ent1{}; // error
    132-"Sdfs"; // error
    3.0f + Double(1.0);
    Double(1.0) + 3.0f;
    var fl : Float;
    fl := 3.0f + Double(1.0); // Type of expression being assigned 'Double' is incompatible with type in left-hand side 'Float'
    fl := Double(1.0) + 3.0f; // Type of expression being assigned 'Double' is incompatible with type in left-hand side 'Float'
    123-123;
    1.0*1.0;
    23423%2345;
    23423.0 % 2345.0;
    true && true || false == true;
    "" == 1; // error
    1.1 != "123"; // error
    Ent1{} == Ent1{};
    Ent2{} != Ent1{};
    now() == today();
    sarg != "" as Email;
    sarg == 123; // error
}

