application test

define page root(){
  main()
  define body() {
    var aa := Patient{ } ;
    init {
      aa.name := "1"; 
    }
  }
}

entity Patient{
  name :: String
}
  
define main(){}
define body(){}  
  

principal is Patient with credentials name
  
access control rules

  rule page *(*){true}
  rule template *(*){true}
    