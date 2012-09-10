application test

  entity Book{
    title :: String
  }

  define page root(){}
  
  define show(){
    var books := [Book{ title := "1" }, Book{ title := "2" }, Book{ title := "3" }]
    
    for(i in books){
      output(i.title)  
    } 
    for(i in books where i.title != "1" order by i.title desc){
      output(i.title)  
    } 
    "-"
    output(show(books))
  }
  
  function show(b : List<Book>):String{
    var r := "";
    for(x in b){
      r := r + x.title;
    }
    for(x in b where x.title != "2" order by x.title asc){
      r := r + x.title;  
    } 
    return r;
  }
  
  test{
    assert(rendertemplate(show()).contains("12332-12313"));
  }
  