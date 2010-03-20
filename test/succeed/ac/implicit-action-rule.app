application test

  entity News {
    name :: String
  }

access control rules

  principal is News with credentials name

  rule page root(){
    true
  }
  rule page editNews(*){false}	// actions in page get the same check unless nested action rules are defined

section test
  
  define page editNews(n: News){
    action save(){  }
    submit save() { "save" }
  } 
  
  var n_1 :=News{}
  
  define page root(){
    navigate editNews(n_1) {"edit"}
  }

  