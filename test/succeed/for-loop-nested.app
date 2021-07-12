application test

section bla
  
  entity Item{
    name : String
  }
  
  entity Bucket{
    name : String
    items : List<Item>
  }
  
  entity Log{
    msg : String
  }
  
  var e1 := Item { name := "e1" }
  var log := Log{ msg := "Buckets with name b1: " }
  
  var bucket1 := Bucket{ name:= "b1" }
  var bucket2 := Bucket{ name:= "b2" }
  
  
  define page root(){
    nestedForLoops
  }
  
  template nestedForLoops{
    var buckets := [bucket1, bucket2]
    
    init{
      bucket1.items := [e1, e1];
      bucket2.items := [e1];
    }

    for( b in buckets ){
      "Bucket ~b.name with items ["
      for(i in b.items){
        ~i.name
      } separated-by{ ", " }
      "]"
      
      //bug: the above nested for-loop causes the internal name `forelementcounter` to be reset to the id of the last item i,
      //causing the condition below to evaluate to the same cached value (because of key uses `forelementcounter`) in each iteration.
      //the value is cached only outside render phase, so this issue only seems to happen during databind/validation/action/. 
      if(b.name == "b1"){
        validate{ log.msg := log.msg + b.name; }
      }
    } separated-by{ br }
  }
  
  test nested_forloop_cached_conditional{
    validatetemplate( nestedForLoops() );
    assert( log.msg == "Buckets with name b1: b1", "Only bucket with name b1 should be logged");
  }
