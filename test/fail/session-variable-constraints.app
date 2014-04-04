//#2 Session variable test is not allowed in inputs
//#4 Session variable test is not allowed as Ref argument
//#2 Invalid argument: 'session.test' is not assignable
//#2 Assignment to session variable 'test' is not allowed

application test

session test { name : String }

page root(){
  form{
    input(test)
    input(session.test)
    refargtemplate("dfdfss",test)  
    refargtemplate("dfdfss",session.test)  
    submit action{
      test := Test{};
      session.test := Test{};
    } {"save"}
  }
}

template refargtemplate(a:String, b:Ref<Test>){ 
  form{
    input(b)
    submit action{} {"save"}
  }
}
