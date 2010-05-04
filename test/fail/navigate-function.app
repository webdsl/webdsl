//no page with signature testpge
application test

  define page root(){
    output(navigate(testpge(432,"3wnrof4twh")))
  }
  
  define page testpage(i:Int,s:String)
  {
    output(i)
    output(s)
  }
