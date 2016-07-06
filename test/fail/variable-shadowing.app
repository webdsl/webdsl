//#6 Variable name 'a' is already defined in this context
//#4 Placeholder name 'a' is already defined in this context
//#8 For loop variable name 'a' is already defined in this context
//#1 List comprehension variable name 'a' is already defined in this context
//#1 Formal argument name 's' is already defined in this context

application shadowing

  page root(){
    var a := 0
    
    var a := 0 // TemplateVarDeclInitInferred
    var a:Int := 0 // TemplateVarDeclInit
    var a:Int // TemplateVarDecl
    
    action bla(){ 
      var a := 0; // VarDeclInitInferred
      var a:Int := 0; // VarDeclInit
      var a:Int; // VarDecl
    }
    
    placeholder a { } // Placeholder
    placeholder <span> a { } // Placeholder
    placeholder a foo() // PlaceholderWithAjaxCall
    placeholder <span> a foo() // PlaceholderWithAjaxCall
    
    for(a:TestEnt){} // ForAll
    for(a:TestEnt in [TestEnt{}]){} // For
    for(a in [TestEnt{}]){} // ForInferred
    for(a:Int from 0 to 5){} // ForCount
    
    action fors(){ 
      for(a:TestEnt){} // ForAllStmt
      for(a:TestEnt in [TestEnt{}]){} // ForStmt
      for(a in [TestEnt{}]){} // ForStmtInferred
      for(a:Int from 0 to 5){} // ForCountStmt
    }
    
    output([a | a:Int in [1]]) // ForExp
    
  }
  
  ajax template foo(){}

  template labelInternal1(s:String, tname :String, tc :TemplateContext){}

  template labelcolumns1(s:String){
    label(s)[all attributes]{
      elements()
    }
    template labelInternal1(s:String, tname :String, tc :TemplateContext){ // Arg
      <td>
      <label for=tname all attributes>output(s)</label>
      </td>
    }
  }

  entity TestEnt{
    function a(name: String){}  // name is allowed, even though it is an implicit property name for any entity
    extend function a(name: String){}
    function b(name: Int){}
  }
  