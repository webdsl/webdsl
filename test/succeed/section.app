application section

section pages

define page root() {
  header{"0"}
  section[class="test", style= "qwerty"+123]{header{"1"}
  section[class="test2"]{header{"2"}
  section{header{"3"}
  section{header{"4"}
  section{header{"5"}
  section{header{"6"}
  section{header{"7"}
  section{header{"8"}
  
  }}}}}}}}
  
  sectemp(10) 
 
}

define sectemp(level:Int){
  section{
    header{output(level)}
    if(level > 0){
      sectemp(level - 1)
    }
  }
}
