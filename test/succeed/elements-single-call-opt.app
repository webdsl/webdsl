application test

page root(){
  helper
}

template helper(){
  elemscall {
    simple
  }
  elemscall {
    elemscall {
      simple
    }
  }
  editSession{
    simple
  }
}

template elemscall(){
  var preventinline := 0
  <div>elements</div>
}

template simple(){
  var preventinline := 0
  "1"
}

test{
  var x := rendertemplate(helper());
  log(x);
  assert(x.contains("<div>1</div><div><div>1</div></div>1234"));
}

// particular combination that was causing compilation issue:

entity PS{
  s : String
}
var ses1 := PS{}
template editSession(){
  elements
  accordionPanels{
    panelBody{
      addMemberToCollection( ses1.s )
    }
  }
}

define panelBody(){
  elements
}

template accordionPanels(){
  template panelBody(){
    elements
    "3"
  }
  elements
  "4"
}

template addMemberToCollection( s:ref String ){
  elements
  "2"
}
