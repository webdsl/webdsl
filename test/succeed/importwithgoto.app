application test

imports module/module/goto

section needsimport

  define body() {
    "default body"
  }
  
  define page home3(){
    main()
    init{
      goto home2();
    
    }
    define body()
    {

    }
   }
