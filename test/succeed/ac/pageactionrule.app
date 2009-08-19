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
    rule page testpage(first:Int)
    {
      true
      rule action test(second:Int)
      {
        first==second
      }
    }
    rule page root(){true}
    rule template main(){true}

  
section somesection  
  
  define main() 
  {
    body()
  }
  

  define page root(){
  
    title{ "homepage" }
  
    navigate(testpage(6)){"testpage"}
   }
   
   
  define page testpage(a:Int){
    title{ "test" "page" }
    main()
    define body()
    {
      form{
        action("test",test(6))
      }
    
    
      action test(a:Int)
      {
        return root();
      }
    }
   }