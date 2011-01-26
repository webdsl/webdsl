application attributes

section pages

define template attrtest() {
  output(attribute("kop", "1"))
  output(attribute("kop2", "2"))
  output(attribute("kop3", "3"))
}

define page root() {
  "expects:: hoitest3:"
  attrtest[kop= "hoi", kop2 = "test"]
  attrtest2[onclick:=action{}, class= "attrtest2class", style ="background-color:yellow;", kop = "hoi", kop2 = "test"]
  
  
  //rndButton("click text above",true)[onclick := action { return bla(); }, style:="background-color:yellow;", class:="classtest", testattr := "testattrvalue"]
}
  define attrtest2(){
    var s := "style";
     container[
        class ="scopediv border rndButton "+attribute("class",""), 
        onclick = ""+attribute("onclick",""),
        style  = attribute("style"),  
        all attributes,
        attributes "style",
        attributes ["style"],
        all attributes except {"class",s},
        all attributes except s
         
   ] {
     "container"
   }
    
   <div
        class="scopediv border rndButton "+attribute("class","") 
        onclick= ""+attribute("onclick","")
        style = attribute("style")
        all attributes
        attributes "style"
        attributes {s,"class"}
        all attributes except ["class",s]
        all attributes except s
    >
      "div" 
    </div>
  }
/*
    define no-span rndButton(kind: String, showCaption: Bool) {
      container[
        class:="scopediv border rndButton "+attribute("class",""), 
        onclick:= ""+attribute("onclick",""),
        style := attribute("style"),  
        all attributes,
        attributes class,style
        all attributes except style, class,
        attributes style, class,
        
        attributes ["style"],
        attributes "style","class",
        all attributes except ["style", "class"],
        all attributes except "style", "class",
         
      ] {
        "THEBUTTON"
        if (showCaption == true) { 
           break
           output(kind)
        }
      }
    }
 */   
    define page bla(){"redirected to bla"}

  