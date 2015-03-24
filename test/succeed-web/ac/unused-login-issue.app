application test

page root(){
  authentication
  logout
}

override template login(){
  test1
}

// should not be dropped by unused template analysis
template test1(){
  "testlogin"
}

override template logout(){
  test2
}

template test2(){
  "testlogout"
}

principal is Someone with credentials name

entity Someone{
  name : String
}

access control rules
  rule page root(){true}
  

section test

test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  assert(d.getPageSource().contains("testlogin"));
  assert(d.getPageSource().contains("testlogout"));
}