// #9 Ajax template call cannot have attributes or elements
// #5 'elements' call cannot have attributes or elements
// #2 Template with signature telems() not defined
// #5 Call to argument with type 'TemplateElements' cannot have attributes or elements
// #34 Pages and ajax templates cannot be passed attributes or elements

application test

page root(){
  placeholder x1 simple1[ all attributes, all attributes except ["class"], attributes["class"] ]{ "123" elements }
  placeholder x2 simple1{ "123" }
  placeholder x3 simple1[ all attributes ]
  action y(){
    replace("noph", simple2[ all attributes, all attributes except ["class"], attributes["class"] ]{ "123" elements });
    append( "noph", simple3[ all attributes, all attributes except ["class"], attributes["class"] ]{ "123" elements });
    replace("noph", simple2{ "123" });
    append( "noph", simple3{ "123" });
    replace("noph", simple2[ all attributes ]);
    append( "noph", simple3[ all attributes ]);
  }
}

page pagetest( telems: TemplateElements, contents: [title: String, nav: TemplateElements] ){
  elements
  elements[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
  div[ all attributes, all attributes except ["class"], attributes["class"] ]
  <div all attributes all attributes except ["class"] attributes["class"]></div>

  // current analysis does not resolve this anyway in page context, so 2x not defined error
  telems() 
  telems[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }

  for( c in contents ){
    c.nav
    c.nav[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements } 
  }
  for( i: Int from 0 to 100 ){  
    elements
    if( 42 > 0 ){
      elements
    }   
  }
}

ajax template ajaxtest( telems: TemplateElements, contents: [title: String, nav: TemplateElements] ){
  elements
  elements[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
  div[ all attributes, all attributes except ["class"], attributes["class"] ]
  <div all attributes all attributes except ["class"] attributes["class"]></div>
  telems()
  telems[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
  for( c in contents ){
    c.nav
    c.nav[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements } 
  }
  for( i: Int from 0 to 100 ){  
    elements
    if( 42 > 0 ){
      elements
    }   
  }
}

ajax template simple1(){}
ajax template simple2(){}
ajax template simple3(){}

template pagetest( telems: TemplateElements, contents: [title: String, nav: TemplateElements] ){
  for( i: Int from 0 to 100 ){  
    elements[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
    telems[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
    for( c in contents ){
      c.nav[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements } 
    }
  }
}

// local redefines should still be allowed to have elements:

page nested(){
  template x(){
    elements
    elements[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
    div[ all attributes, all attributes except ["class"], attributes["class"] ]
    <div all attributes all attributes except ["class"] attributes["class"]></div>
  }
}

ajax template nestedajax(){
  template x(){
    elements
    elements[ all attributes, all attributes except ["class"], attributes["class"] ]{ elements }
    div[ all attributes, all attributes except ["class"], attributes["class"] ]
    <div all attributes all attributes except ["class"] attributes["class"]></div>
  }
}

template x(){}
