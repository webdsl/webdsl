//Circular variable definition detected

application test

define page root() {}

var one := two;
var two := one;

