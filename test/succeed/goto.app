application test

section datamodel

  entity User{
    name :: String
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    init{
      goto home2();
    
    }
    define body()
    {

    }
   }
   
  define page home2(){
    main()

    define body()
    {

    }
   }