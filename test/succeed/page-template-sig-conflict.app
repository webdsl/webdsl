//don't want to see the 'Cannot use page as template' error here

application bla

  define bar(i:Int){}

  define page bar(i:Int){}
 
  define page root(){
    bar(5)
  }