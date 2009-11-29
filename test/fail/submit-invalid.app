//Cannot find action with signature

application test

define page root(){
  form{
    submit("go",test(65))
  }
 
  action test(s:String){
    
  }
}