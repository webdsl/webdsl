//like onetooneissue.app many-to-many could cause problems as well, although in this case the version property of A and B is updated, preventing
//concurrent edits of the inverse Sets
application test

  entity A {
    b -> Set<B>
  }
  
  entity B {
    a -> Set<A> (inverse=A.b)
  }
  
  var a1 := A{}
  var b1 := B{}

  define page root(){
    init{
      a1.b.add(b1);
    }
    "A.b "
    output(a1.b)
    /*
    <br />
    "b1 "
    output(b1)*/
  }
  

  define page root1(){
    init{
      a1.b.clear();
    }
  }
  
  // ab -n1000 -c10 http://localhost:8080/manytomanyissue/
  // ab -n1000 -c10 http://localhost:8080/manytomanyissue/root1

