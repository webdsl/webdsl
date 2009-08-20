application test

section bla
  
  entity Test {
    test :: Int
  }
  
  var t_1 := Test{ test := 1 }
  var t_2 := Test{ test := 2 }
  var t_3 := Test{ test := 3 }
  
  define page root(){
    
    for(i:Int in [1,2,3,4,5,6,7] where i > 3 order by i desc limit 2){
      output(i)
    } separated-by { ", " }
    break
    "example should show 7, 6"
    break
    for(i:Int from 4 to 7){
      output(i)
    } separated-by { ", " }
    break
    "example should show 4, 5, 6"
    break
    for(t:Test order by t.test asc){
      output(t.test)
    } separated-by { " -- " }
    break
    "example should show 1 -- 2 -- 3"
  }
