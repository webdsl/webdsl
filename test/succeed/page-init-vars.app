application test

//a bug caused vars in page inits to be generated as page vars

 define page root(){
   init {
     var i : Int := 1;
     var s :String := "test";
     var s1 :String := "test";
     var s2 :String := "test";
     var s3 :String := "test";
     var s4 :String := "test";
   }
 }