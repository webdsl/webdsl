//Cannot find action with signature

application test

  define page root(){
    output("dafsdsf")[onclick := fi() ]
    
    placeholder bla{}
    
    action fill(){
      replace(bla,template{ "bla" });
    }
  }

  function fi(){}