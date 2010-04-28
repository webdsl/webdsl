//expression 4 has type Int
//has type List<Bool>
//has type List<Float>
//expression Test{} has type Test
//expression Test{} has type Test
//has type List<Test>
// has type List<Int>
//expression false has type Bool

application test
entity Test{}

define page root(){
   container[
        class ="scopediv border rndButton "+attribute("class",""), 
        onclick = ""+attribute("onclick",""),
        style  = attribute("style"),  
        all attributes,
        attributes 4,
        attributes [true],
        all attributes except [0.0,0.1],
        all attributes except Test{}
         
   ] {

   }
    
   <div
        class="scopediv border rndButton "+attribute("class","") 
        onclick= ""+attribute("onclick","")
        style = attribute("style")
        all attributes
        attributes Test{}
        attributes [Test{}]
        all attributes except [4,4,6,4,56]
        all attributes except false
    >
     
    </div>
}
