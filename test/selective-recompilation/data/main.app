module main

define buttons(){
  hello with{
  hoi(){
  form{
    submit action{   
      Bla{}.save();
      Tmp{}.save();
    } {"save"}
  }
  }
  }
 
}
  
  define hello() requires hoi(){
    hoi()
  }
  
 

  
define page root(){
    buttons()
    "123"
    "456"
    foobar
    refs()
}
  
define foobar(){
  init{
    Bla{}.save();
    Tmp{}.save();
  }
  "aaee56464646456"
  output(Bla{}.name)
  output(Tmp{}.name)
}
  
  
entity Tmp{tmp::String}
  
  
  entity C{tmp -> Tmp}

 define refs(){
   var tmp := Tmp{tmp:="123"};
   var c := C{tmp:=tmp}
  init{
    c.save();
  }
  testreftpl(c.tmp)
  //navigate testref(c.tmp) { "go"}
  submit action{replace(abc,testrefajax(c.tmp));} {"ajax"}
  placeholder abc {}
}
 
 define testreftpl(s:Ref<Tmp>){
    output(s)
  }
  define page testref(s:Ref<Tmp>){
    output(s)
  }
  
  define ajax testrefajax(s:Ref<Tmp>){
    output(s)
    submit action{replace(abc,testrefajax(s));} {"ajax"}
  }