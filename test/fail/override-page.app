//override page must override an existing page
//#2 multiple overrides for the same page signature

application test

  //define page blapagedoesnotexist(s:String, i :Int){ }
  define override page blapagedoesnotexist(s:String, i :Int){}
  
  define override page root(){ "1" }
  define override page root(){ "2" }

  define page root(){
  }
  