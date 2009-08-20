application test

section datamodel

  entity User{
    name :: String
  }
  
  define body() {
    "default body"
  }

  entity GeenUser
  {
    name :: String
  }
  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    var u:User := User{};
    
    for(p:User){
    output(p.name)
      
    }
    
    for(p:User){
    output(p.name)
    
    }
    
    for(p:GeenUser){
    output(p.name)
    
    }
    
    define body()
    {

    }
   }
