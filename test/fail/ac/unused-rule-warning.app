//#6 Template rule refers to non-existing template
//#5 Page rule refers to non-existing page

application test

entity User{name :: String}

principal is User with credentials name

access control rules

  rule page rot() { true }
  rule page root() { true }
  rule page root(i:Int) { true }
  rule page root(i:Int,u:User *) { true }
  rule page root(*) { true }
  rule page ro*() { true }

  rule page page() { true }
  rule page pa() { true }
  rule page page(i:Int) { true }
  rule page page(u:User, i:Int) { true }
  rule page page(i:Int,u:User *) { true }
  rule page page(*) { true }
  rule page pa*() { true }

  rule template teml(b:Bool) { true }
  rule template templ(b:Bool) { true }
  rule template templ(b:Bool *) { true }
  rule template templ(*) { true }
  rule template te*() { true }
  rule template te*(*) { true }
  rule template teml(u:User) { true }
  rule template templ(u:User) { true }
  rule template templ(u:User *) { true }

  rule ajaxtemplate ateml(b:Bool) { true }
  rule ajaxtemplate atempl(b:Bool) { true }
  rule ajaxtemplate atempl(b:Bool *) { true }
  rule ajaxtemplate atempl(*) { true }
  rule ajaxtemplate ate*() { true }
  rule ajaxtemplate ate*(*) { true }
  rule ajaxtemplate ateml(i:Int) { true }
  rule ajaxtemplate atempl(i:Int) { true }
  rule ajaxtemplate atempl(i:Int *) { true }

  rule action act() { true }
  
section pages  
  
  define page root(){}
  define page page(u:User,i:Int){}
  
  define templ(){}
  define templ(u:User){
    action("action",act())
    action act(){
    }
  }
  
  define ajax atempl(i:Int){}
  define ajax atempl(){}
