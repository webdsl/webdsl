application test

page root(){
  tmpl
}

template tmpl(){
  submit action{}[ col attributes ]{}
}

attributes col{
  ignore submit attributes
  class = "SUCCESS"
}

override attributes submit{
  class = "ERROR"
}

test{
  log( rendertemplate( tmpl ) );
  assert( rendertemplate(tmpl).contains("SUCCESS") );
  assert( ! rendertemplate(tmpl).contains("ERROR") );
}