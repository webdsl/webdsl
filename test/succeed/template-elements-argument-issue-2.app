application test

page root(){
  roottemp
}

template roottemp(){
  testtemplate(
    { <a>"1"</a> },
    { <a>"2"</a> },
    { <a>"3"</a> }
  )
}

template testtemplate(headerelements1: TemplateElements, headerelements2: TemplateElements, headerelements3: TemplateElements){
  testContainer("", ""){
    <div>
      headerelements1
      headerelements2
      headerelements3
    </div>
  }
  testContainer("", "")
}

template testContainer(image:String, alt:String){
  <div class="" all attributes>
    <div class="">
      <div class="">
        elements
      </div>
    </div>
    <div class=""><img src=image alt=alt></div>
  </div>
}

test{
  log(rendertemplate(roottemp));
  assert(rendertemplate(roottemp).contains("<a>1</a><a>2</a><a>3</a>"));
}