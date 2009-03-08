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