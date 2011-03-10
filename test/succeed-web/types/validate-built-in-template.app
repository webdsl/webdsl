// definition for the validate template 

application test
  
  define page root(){
    var i := 0
    form{
      input(i)
      validate(i>2,"i must be greater than 2")
      submit action{} {"save"}
    }
  }
 