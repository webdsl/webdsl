application test

section datamodel

  entity User{
    name :: String
  }


  define page root(){
    var u:User := User{name := "bob"};
    var s:String := "dgfdfgd"
    "homepage"
    output(u.name)
    output(s)
    
    "call:"
    
    temparg(u,s)
    
    define homelocal(u11:User,s11:String)
    {
      "locally defined template"
      output(u11.name)
      output(s11)
      output(u.name)
      output(s)
      
    }
    
  }

  define temparg(u:User,s:String)
  {
    "temparg"
    output(u.name)
    output(s)
      
    temparg2(u,s)
    
    homelocal(u,s)
  }

  define temparg2(u:User,s:String)
  {
    "temparg2"
    output(u.name)
    output(s)
  
  
    homelocal(u,s)
    
    temparg3(s)
    
    temparg4(u)

  }

  define temparg3(s:String)
  {
    "temparg3"
    output(s)

  }
  
  define temparg4(u:User)
  {
    "temparg4"
    output(u.name)
  }


  define homelocal(u:User,s:String)
  {
    "not this one"
  }
