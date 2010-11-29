//#2 Assigning to an inverse property when initializing

application test

  entity Evaluation {
    course -> Course (inverse=Course.evaluation)
  }
  entity Course{
    evaluation -> Evaluation
  }

  var e1 := Evaluation{}

  define page root(){
    "courses: " output(select count(*) from Course as c)
    "evaluations: " output(select count(*) from Evaluation as e)
    
    var c2 : Course := Course{ evaluation := e1 }
    var c := Course{ evaluation := e1 }
    
    testtemplate{ 
      form{
        submit action{c.save();} {"save"}
      }
    }    
  }
  
  define testtemplate(){
    elements()
  }
  
  