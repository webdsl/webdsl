//#2 Multiple template definitions with signature test(Int, String, WikiText, Float)

application test

  define page root(){
  }
  
  define test(i:Int, s:String, w:WikiText, f:Float){ "1" }
  define test(i:Int, s:String, w:WikiText, f:Float){ "2" }
