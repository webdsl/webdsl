application test

test{
  assert(rendertemplate(commentAdditionInput()).contains("123</div>_456"));
  assert(rendertemplate(testfors()).contains("12"));
  assert(rendertemplate(testfors()).contains("3</div>4"));
  assert(rendertemplate(refs()).contains("123"));
}


page root(){
  commentAdditionInput
}

template commentAdditionInput() {

  action update1(s:String){ replace(commentPreview,ajaxtest(s));}
  submit update1("test_1"){ "test1" }
  div[onclick=update1("test_2")]{ "test2" }

  action update2(s:String, c:Placeholder){ replace(c,ajaxtest(s)); }
  submit update2("test_3", commentPreview){ "test3" }
  div[onclick=update2("test_4", commentPreview)]{ "test4" }

  submit action{ replace(commentPreview,ajaxtest("test_5"));} { "test5"}
  div[onclick=action{ replace(commentPreview,ajaxtest("test_6"));}]{ "test6"}

  templ {
    placeholder commentPreview { "123" }
    templ(){ "456" }
  }
}

template templ(){
  "_"
  elements
}

ajax template ajaxtest(s:String){ output(s) }



entity Question{}

template testfors(){
  var qs1 := [Question{}]
  for(q in qs2){
    "1"
  }
  var qs2 := [Question{}]
  for(q in qs2){
    "2"
  }
  placeholder commentAdditionBox{
    "3"
  }
  var qs3 := [Question{}]
  for(q in qs2){
    "4"
  }
}


template testwith(){
  var vartest := "123"
  output(phtest)
  placeholdervar phtest
  tw() with {
    s() {  output(vartest) output(phtest) }
  }

}
template tw() requires s() {
  s()
}


template refs(){
  placeholder abc { "123" }
  submit action{ replace(abc, testrefajax(abc, "456")); } {"ajax"}
}
ajax template testrefajax(a:Placeholder, s:String){
  output(s)
  submit action{ replace(a, testrefajax(a, s)); } {"ajax"}
}