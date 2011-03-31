//override template must override an existing template
//#2 multiple overrides for the same template signature

application test

  define override bladoesnotexist(s:String){
  }
  
  define override div(){ "1" }
  define override div(){ "2" }

  define page root(){
  }
  