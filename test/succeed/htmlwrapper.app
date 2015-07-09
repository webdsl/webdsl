application testhtmlwrapper

page root(){
  testtemplate
}

template testtemplate(){
  testh1[class="test1"]{"a1"}
  testh2[class="test2"]{"a2"}
  testh3[class="test3"]{"a3"}
  testh4[class="test4"]{"a4"}
}

htmlwrapper testh1 h1
htmlwrapper testh2 h2[class="testclass2" role="testrole2"]
htmlwrapper{
  testh3 h3
  testh4 h4[class="testclass4" style="teststyle4"]
}

test{
  assert(rendertemplate(testtemplate()).contains(
    "<h1 class=\"test1\">a1</h1>"
  + "<h2 role=\"testrole2\" class=\"testclass2 test2\">a2</h2>"
  + "<h3 class=\"test3\">a3</h3>"
  + "<h4 class=\"testclass4 test4\" style=\"teststyle4\">a4</h4>"));
}