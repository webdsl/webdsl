// this causes a java compilation error in rev 3809 due to a comparison of primitive int and null in generated code "incomparable types: int and <nulltype>"
// rev 6009: actual argument int cannot be converted to String by method invocation conversion

application test

  page root(){
    templatetest
  }

  template templatetest(){
    <div class=[1].length />
    <div style=[1].length />
    <div foo=[1].length />
  }

  test{
    var t := rendertemplate(templatetest());
    assert(t == "<div class=\"1\"/><div style=\"1\"/><div foo=\"1\"/>");
  }