//with signature anFunctionNoReturn() is defined multiple times
//with signature anFunctionReturn() is defined multiple times
//with signature anFunction() is defined multiple times
//Multiple definitions with name 'aPage'
//Multiple definitions with name 'aTemplate'
//Multiple definitions with name 'aDefine'
//anEntityNoSuper is defined multiple times
//anEntity is defined multiple times
//aSessionEntity is defined multiple times
//ADoubleEntity is also defined as normal entity

application test

function anFunctionReturn() : Int { return 3; }
function AnFunctionReturn() : Int { return 3; }
function anFunctionNoReturn() { }
function AnFunctionNoReturn() { }
function anFunction() : Int { return 3; }
function AnFunction() { }

// defines

define page aPage () { }
define page APage () { }

define template aTemplate() { }
define template ATemplate() { }

define page 		aDefine () { }
define template	ADefine () { }

// entities

entity anEntityNoSuper { }
entity AnEntityNoSuper { }

entity anEntity { }
entity AnEntity { }

session aSessionEntity { }
session ASessionEntity { }

entity		aDoubleEntity { }
session 	ADoubleEntity { }

// entity function

entity X {
	function anFunction() { }
	function AnFunction() { }
}

// entity and function
entity EntityFunction { }
function EntityFunction() { }

// page and function
define page PageFunction() { }
function PageFunction() { }

// ----------------------

define page root () { }
