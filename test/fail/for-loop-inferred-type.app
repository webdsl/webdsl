//#2 Variable 'bookz' not defined
//#2 Variable 'bo' not defined

application test

  entity Book{
    title :: String
  }

  define page root(){}
  
  define show(){
    var books := [Book{ title := "1" }, Book{ title := "2" }, Book{ title := "3" }]
    
    for(i in bookz){  //rename phase should not break on this, cannot determine type for i here
      output(i.title)  
    } 
    for(i in bookz where i.title != "1" order by i.title desc){
      output(i.title)  
    } 
    "-"
    output(show(books))
  }
  
  function show(b : List<Book>):String{
    var r := "";
    for(x in bo){
      r := r + x.title;
    }
    for(x in bo where x.title != "2" order by x.title asc){
      r := r + x.title;  
    } 
    return r;
  }
  