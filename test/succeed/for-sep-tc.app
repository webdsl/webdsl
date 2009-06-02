application test

section bla
  
  define page home(){
    
    for(i:Int in [1,2,3,4,5,6,7] where i > 3 order by i desc limit 2){
      output(i)
    } separated-by { ", " }
    break
    "example should show 7, 6"
  }
