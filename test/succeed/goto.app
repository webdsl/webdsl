application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    init{
      goto root2();
    
    }
    define body()
    {

    }
   }
   
  define page root2(){
    main()

    define body()
    {

    }
   }
