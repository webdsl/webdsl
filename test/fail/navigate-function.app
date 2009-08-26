//No function or page 'testpae' with signature
application test

  define page root(){
    output(navigate(testpge(432,"3wnrof4twh")))
  }
  
  define page testpage(i:Int,s:String)
  {
    output(i)
    output(s)
  }
