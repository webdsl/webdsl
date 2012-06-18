module data

  entity Foo {
    s::String
  }
  
  principal is Foo with credentials s
  
  access control rules
    rule page root(){
      1==0
    }
    rule template *(*){
      true
    }