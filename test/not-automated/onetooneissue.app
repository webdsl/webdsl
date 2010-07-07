application test

  entity A {
    b -> B
  }
  
  entity B {
    a -> A (inverse=A.b)
  }
  
  var a1 := A{}

  define page root(){
    init{
      //will break db on concurrent access when a1.b was null, because there is no transaction conflict (only row of B is updated), 
      // but there is a logical conflict (multiple B's pointing to A) which breaks subsequent queries
      a1.b := B{};
    }
  }
  

  define page root1(){
    init{
      a1.b := null;
    }
  }
  
  // ab -n1000 -c10 http://localhost:8080/onetooneissue/
  // ab -n1000 -c10 http://localhost:8080/onetooneissue/root1

