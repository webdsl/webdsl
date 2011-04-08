//#2 Multiple page/template definitions with name 'root'
//#3 Multiple page/template definitions with name 'home2'
//#2 Multiple page/template definitions with name 'test'

application test

section datamodel

  entity User{
    name :: String
  }
  

  define main() 
  {
    body()
  }
  
  define page home2(){
      main()
  }
  define page home2(){
      main()
  }
  define page home2(){
      main()
  }

  define page root(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }
   
  define page root(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }
   
section bla

  define page test(){title{"1"}}
  define page test(){title{"2"}}
  
  define body(){ "default body" }
   
