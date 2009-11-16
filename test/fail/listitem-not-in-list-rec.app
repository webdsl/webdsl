//listitem not wrapped in list
application test

define page root() {
  test
}

define test(){
  test2
  listitem{
    "1"
  }
}

define test2(){ 
  list { test } 
}
