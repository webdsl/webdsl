application test

section datamodel

  define body() {
    "default body"
  }
  
  session user{
    name :: String
  }
  
  define main() 
  {
    body()
  }
  
  define page root(){
    main()
   
    define body()
    {
      action save(){}
      output(user.name)
      form{
        "session entities shouldn't be used directly in inputs, no way to cancel after data has been bound"
        input(user.name)
        action("save",save())
      }
    }
   }
