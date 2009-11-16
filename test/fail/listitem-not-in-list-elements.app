//listitem not wrapped in list
application test

define page root() {
  elementsnotwrapped{
    listitem{"sfs"}
  }
  elementswrapped{
    listitem{"sfs"}
  }
}

define elementsnotwrapped(){
  elements
}
define elementsnotwrapped(i:Int){
  elements
}

define elementswrapped(){
  list{
    elements
  }
}