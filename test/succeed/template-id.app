application test

page root(){
  output(id)
}

entity Foo{
  s: String
  
  function bar(): String{
    log(id);
    return id.toString();
  }
}

test{
  assert(Foo{}.bar().length() == 36);
}