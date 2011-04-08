//with signature anFunctionNoReturn() is defined multiple times
//with signature anFunctionReturn() is defined multiple times
//with signature anFunction() is defined multiple times
//#1 Multiple page/template definitions with name 'aPage'
//#1 Multiple page/template definitions with name 'APage'
//#1 Multiple page/template definitions with name 'aTemplate'
//#1 Multiple page/template definitions with name 'ATemplate'
//#1 Multiple page/template definitions with name 'aDefine'
//#1 Multiple page/template definitions with name 'ADefine'
//#2 Multiple page/template definitions with name 'pageArgsAndTemplateNoArgs'
//'anEntityNoSuper' is defined multiple times
//'anEntity' is defined multiple times
//'ASessionEntity' is defined multiple times
//'ADoubleEntity' is defined multiple times

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

define page     pageArgsAndTemplateNoArgs (x : String) { }
define template pageArgsAndTemplateNoArgs () { }


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
