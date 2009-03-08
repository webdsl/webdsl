application test

section principal

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule action save()
    {
      1==1
    }
    rule template main()
    {
      true
    }
    rule page home(){
      true
    }


  
section somesection  
  
  define main()
  {
    body()
  }
  
  define page home(){
    main()
    define body(){
      form{
        action("save",save())    
      }


      action save()
      {
        1==1;
      }
    }
  }