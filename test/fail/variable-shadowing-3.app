//#6 Variable name 'rvar1' is already defined in this context
//#4 Placeholder name 'rvar1' is already defined in this context
//#8 For loop variable name 'rvar1' is already defined in this context
//#1 List comprehension variable name 'rvar1' is already defined in this context
//#6 Variable name 'rvar2' is already defined in this context
//#4 Placeholder name 'rvar2' is already defined in this context
//#8 For loop variable name 'rvar2' is already defined in this context
//#1 List comprehension variable name 'rvar2' is already defined in this context
//#6 Variable name 'gvar1' is already defined in this context
//#4 Placeholder name 'gvar1' is already defined in this context
//#8 For loop variable name 'gvar1' is already defined in this context
//#1 List comprehension variable name 'gvar1' is already defined in this context
//#6 Variable name 'gvar2' is already defined in this context
//#4 Placeholder name 'gvar2' is already defined in this context
//#8 For loop variable name 'gvar2' is already defined in this context
//#1 List comprehension variable name 'gvar2' is already defined in this context
//#6 Variable name 'svar' is already defined in this context
//#4 Placeholder name 'svar' is already defined in this context
//#8 For loop variable name 'svar' is already defined in this context
//#1 List comprehension variable name 'svar' is already defined in this context

application shadowing

request var rvar1 := "123"
request var rvar2: String := "123"
var gvar1 := TestEnt{}
var gvar2: TestEnt := TestEnt{}
session svar {}

expand rvar1 rvar2 gvar1 gvar2 svar to x {
  page x1 {
    var x := 0 // TemplateVarDeclInitInferred
  }
  page x2 {
    var x: Int := 0 // TemplateVarDeclInit
  }
  page x3 {
    var x: Int // TemplateVarDecl
  }
  page x4 {
    action bla {
      var x := 0; // VarDeclInitInferred
    }
    action bla1 {
      var x: Int := 0; // VarDeclInit
    }
    action bla2 {
      var x: Int; // VarDecl
    }
  }
  page x5 {
    placeholder x { } // Placeholder
  }
  page x6 {
    placeholder <span> x { } // Placeholder
  }
  page x7 {
    placeholder x foo() // PlaceholderWithAjaxCall
  }
  page x8 {
    placeholder <span> x foo() // PlaceholderWithAjaxCall
  }
  page x9 {
    for(x:TestEnt){} // ForAll
  }
  page x10 {
    for(x:TestEnt in [TestEnt{}]){} // For
  }
  page x11 {
    for(x in [TestEnt{}]){} // ForInferred
  }
  page x12 {
    for(x:Int from 0 to 5){} // ForCount
  }
  page x13 {
    action fors {
      for(x:TestEnt){} // ForAllStmt
    }
    action fors1 {
      for(x:TestEnt in [TestEnt{}]){} // ForStmt
    }
    action fors2 {
      for(x in [TestEnt{}]){} // ForStmtInferred
    }
    action fors3 {
      for(x:Int from 0 to 5){} // ForCountStmt
    }
  }
  page x14 {
    output([x | x: Int in [1]]) // ForExp
  }
}

entity TestEnt {}
ajax template foo() {}
page root {}
