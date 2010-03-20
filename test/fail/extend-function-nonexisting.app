//with signature x(Int) extends a non-existing function
//with signature x(String) extends a non-existing function
//with signature y() in User extends a non-existing function
//with signature y(Int) in User extends a non-existing function

application test

function x() { }

extend function x(i : Int) { }
extend function x(s : String) { }

entity User {
   
   function y(s : String) { }
   
   extend function y() { }
   extend function y(i : Int) {}
   
}