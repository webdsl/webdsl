//listitem not wrapped in list
application test

define page root() {
  list{
    notok
    listitem{"111"}
    test
    
  }
  test
  
  ok
  
  notok
  
}

define test(){
  bla
}

define bla(){
 listitem{"1"}
}

define ok(){ list { listitem{  "ok" } }}
define notok(){
  listitem{"1"}
  bla
}
