//Variable name 'a1' is never used
//Variable name 'a2' is never used
//Variable name 'a3' is never used
//Variable name 'a4' is never used
//Variable name 'a5' is never used
//Variable name 'a6' is never used
//Variable name 'a7' is never used
//Placeholder name 'a8' is never used
//Placeholder name 'a9' is never used
//Placeholder name 'a10' is never used
//Placeholder name 'a11' is never used
//For loop variable name 'a12' is never used
//For loop variable name 'a13' is never used
//For loop variable name 'a14' is never used
//For loop variable name 'a15' is never used
//For loop variable name 'a16' is never used
//For loop variable name 'a17' is never used
//For loop variable name 'a18' is never used
//For loop variable name 'a19' is never used
//List comprehension variable name 'a20' is never used
//Typecase variable name 'a21' is not used in this block
//Typecase variable name 'a22' is not used in this block

application shadowing

page root {
  var a1 := 0
  var a2 := 0 // TemplateVarDeclInitInferred
  var a3: Int := 0 // TemplateVarDeclInit
  var a4: Int // TemplateVarDecl
  action bla {
    var a5 := 0; // VarDeclInitInferred
    var a6: Int := 0; // VarDeclInit
    var a7: Int; // VarDecl
  }
  placeholder a8 { } // Placeholder
  placeholder <span> a9 { } // Placeholder
  placeholder a10 foo() // PlaceholderWithAjaxCall
  placeholder <span> a11 foo() // PlaceholderWithAjaxCall
  for( a12: TestEnt ){} // ForAll
  for( a13: TestEnt in [TestEnt{}]){} // For
  for( a14 in [TestEnt{}]){} // ForInferred
  for( a15 :Int from 0 to 5){} // ForCount
  action fors {
    for( a16: TestEnt ){} // ForAllStmt
    for( a17: TestEnt in [ TestEnt{} ] ){} // ForStmt
    for( a18 in [ TestEnt{} ] ){} // ForStmtInferred
    for( a19: Int from 0 to 5 ){} // ForCountStmt
  }
  output( [ 2 | a20: Int in [ 1 ] ] ) // ForExp
  var widget := WidgetElem{}
  typecase ( widget as a21 ){
    WidgetElem2 {
      input( a21 )
    }
    WidgetElem {
      input( widgetElem )
    }
    default {
      input( a21 )
    }
  }
  var widgetNoError1 := WidgetElem{}
  typecase ( widgetNoError1 as xyz ){
    default{}
  }
  action foo {
    var wi := WidgetElem{};
    typecase ( wi as a22 ){
      WidgetElem2 {
        log( a22 );
      }
      WidgetElem {
        log( a222 );
      }
      default {
        log( a22 );
      }
    }
    var widgetNoError2 := WidgetElem{};
    typecase ( widgetNoError2 as xyz ){
      default{ log( xyz1 ); }
    }
  }
}

entity WidgetElem{}

entity WidgetElem2 : WidgetElem{}

ajax template foo(){}

entity TestEnt{
  function a(name: String){}
  extend function a(name: String){}
  function b(name: Int){}
}
