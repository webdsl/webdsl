module goto
section datamodel

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
