//unused rules

application test

entity User{name :: String}

principal is User with credentials name

access control rules

  rule page root() {
    true
  }

  rule template tepl(b:Bool) {
    true
  }

  rule action act() {
    true
  }
  
section pages  
  
  define page root(){
    "test"
    templ()
  }
  
  define templ(){
    "test"
    action("action",act())
    action act(){
    
    }
  }