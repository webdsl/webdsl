//#4 pointcut element must use pointcut argument

application test

define page root() {}

define page one(i:Int){}

define test(s:String){}

entity User{name::String}

principal is User with credentials name

access control rules

  rule pointcut somepointcut(c:Int,d:String) {
    (d+c).length()>2
  }
  
  pointcut somepointcut(a:Int,b:String) {
    page root(),
    page one(a),
    template test(b)
  }