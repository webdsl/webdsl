//listitem not wrapped in list
application test

define page root() {
  t0{t1}
}

define t0(){
  elements
}

define t1(){
  if(true){
    t2 {
      listitem{ "adsff" }
    }
  }
}

define t2(){
  if(true){
    elements
  }
}