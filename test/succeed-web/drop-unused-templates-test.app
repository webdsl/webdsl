// test for regressions related to drop unused templates analysis

application test

page root(){

}

template templ(){
  tmp1({ t00[] })
  output(rendertemplate(t01()))
  tmp2([({ t02[] },""),({ t03[] },"")])
}

template tmp1(t:TemplateElements){
  t
}

template tmp2(ts:[te:TemplateElements,s:String]){
  for(t in ts){
    t.te
  }
}

template t00(){
  "test00"
}

template t01(){
  "test01"
}

template t02(){
  "test02"
}

template t03(){
  "test03"
}

test{
  assert(rendertemplate(templ()).contains("test00"));
  assert(rendertemplate(templ()).contains("test01"));
  assert(rendertemplate(templ()).contains("test02"));
  assert(rendertemplate(templ()).contains("test03"));

  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(manageSmall()));
  assert(d.getPageSource().contains("Small"));
}

entity Small{
  name : String
}

derive CRUD Small

