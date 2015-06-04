application test

page root(){
  roottemp
}

template roottemp(){
  testtemplate({ <a>"Get Started"</a> })
}

template testtemplate(headerelements: TemplateElements){
  testContainer("", ""){
    <div>
      headerelements
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
  assert(rendertemplate(roottemp).contains("Get Started"));
}