//http://yellowgrass.org/issue/WebDSL/542

application test

  define page root() {
     showCourseEvaluation(globalCourse)
  }
  
  var globalCourse := Course{evaluations := [Evaluation{}] }
  
  entity Course{
    name :: String
    evaluations -> List<Evaluation>	
  }
  entity Evaluation{
    function bla():Bool{return true;}
  }
  
  define showCourseEvaluation(course : Course) {
    "success template shown"
  }

access control rules
  
  rule page root(){
    true
  }
  rule template showCourseEvaluation(course : Course) {
    Or [eval.bla()| eval : Evaluation in course.evaluations]
  }

section
  
  test{
    assert( Or[eval.bla()| eval : Evaluation in globalCourse.evaluations] == true );
    
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("success template shown"));
  }

principal is Course with credentials name