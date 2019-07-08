application test

page root {
  issue
}

template issue {
  
  controlGroup {
    // ""  adding any element here was working around the issue, single call optimization
    inputRadio( { output( "nog iets" )[] } )
  }
}

template controlGroup {
  controlGroup2{ elements }
}

template controlGroup2 {   
  elements
}

template inputRadio( trueLabel: TemplateElements ){
  trueLabel
}

test{
  var source := rendertemplate( issue() );
  assert( source.contains( "nog iets" ) );
}