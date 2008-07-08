// Global variables can only be of a defined entity type, not a list, set or builtin type.

application test

section datamodel
entity Test {
}

var globalstr : String := "Hallo!";
var testlist : Set<Test> := { Test {} };
