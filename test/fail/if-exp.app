//#1 expression "asd" should be of type Bool
//#1 type Int of expression 2 is not compatible with type String of expression "1"
//#1 type String of expression "2" is not compatible with type Int of expression 1

application ifexp

  define page root(){
    output(if("asd")"1"else"2")
    output(if(1==1)"1"else2)
    output(if(2!=34) 1 else "2")
  }
  
  