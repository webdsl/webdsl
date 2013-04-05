application exampleapp

  define page root(){}
  
  define show(){
    for( t : Tag in ( from Tag order by num ) ) {
      output(t.num)
    }separated-by{"-"}
  }

  entity Tag{
    num :: Int
  }

  
  init {
    for( id:Int from 1 to 22){
      var t := Tag{ num := id };
      t.save();
    }
  }

 test{
   assert(rendertemplate(show()).contains("1-2-3-4-5-6-7-8-9-10-11-12-13-14-15-16-17-18-19-20-21"));
 }
