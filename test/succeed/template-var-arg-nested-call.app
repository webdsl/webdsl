application test

page root(){
  testtemplate
}

template testtemplate(){
  var tmpstring := "test"
  tabs(
    [
      ( "first",
        { div{ "content1" } }
      ),
      ( "second",
        { div{ "content2" } }
      )
    ]
  )
}

template tabs(contents : [title: String, elems:TemplateElements]) {
  for(c in contents){
    wrapper1{
      wrapper2{
        c.elems
      }
    }
  }
}

template wrapper1(){
  elements
}

template wrapper2(){
  elements
  var i := 0
  form{
    input(i)
    submit action{} {"save"}
  }
}

test{
  log(rendertemplate(testtemplate()));
  assert(rendertemplate(testtemplate()).contains("<div>content1</div>"));
  assert(rendertemplate(testtemplate()).contains("<div>content2</div>"));
}
