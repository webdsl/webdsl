//'true' is not assignable
//'2' is not assignable

application test

define page root(){
  test(true,"1",2)
}

define test(a :Ref<Bool>, b : String, c: Ref<Int>){}



