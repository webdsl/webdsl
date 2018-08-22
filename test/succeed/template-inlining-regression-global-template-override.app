// breaks without setting inlinetemplates=false in application.ini
// override is ignored when template can be inlined

application test

page root(){
  helper
}

template helper(){ g }
  
template g(){
  "fail"
}

override template g(){
  "testcontent"
}
  
test{
  assert(rendertemplate(helper).contains("testcontent"));
}
  