//#31 Variable name 'id' is not allowed

application test

entity Test{}

var id := Test{}
var id: Test := Test{}
request var id := Test{}

page root(){
  var id := 0
  
  var id := 0 // TemplateVarDeclInitInferred
  var id: Int := 0 // TemplateVarDeclInit
  var id: Int // TemplateVarDecl

  request var id: Int
  
  action bla(){ 
    var id := 0; // VarDeclInitInferred
    var id: Int := 0; // VarDeclInit
    var id: Int; // VarDecl
  }
  
  placeholder id{} // Placeholder
  placeholder <span> id{} // Placeholder
  placeholder <span> id foo() // PlaceholderWithAjaxCall
  placeholder id foo() // PlaceholderWithAjaxCall
  
  for( id: TestEnt ){} // ForAll
  for( id: TestEnt in [ TestEnt{} ] ){} // For
  for( id in [ TestEnt{} ] ){} // ForInferred
  for( id: Int from 0 to 5 ){} // ForCount
  
  action fors(){ 
    for( id: TestEnt ){} // ForAllStmt
    for( id: TestEnt in [ TestEnt{} ] ){} // ForStmt
    for( id in [ TestEnt{} ] ){} // ForStmtInferred
    for( id: Int from 0 to 5 ){} // ForCountStmt
  }
  
  output( [ id | id: Int in [ 1 ] ] ) // ForExp
}

template tmp1( id: String ){
  template tmp2( id: String ){}
}

entity TestEnt{
  function a( id: String ){} 
  extend function a( id: String ){}
  function b( id: Int ){}
}
  
function testfun( id: String ){}
extend function testfun( id: String ){} 