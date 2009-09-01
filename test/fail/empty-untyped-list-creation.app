//Type cannot be determined for empty untyped list creation
application test
 
  define page root(){
    output([].length)
  }