application root

  attributes regular {
    class = "rc"
    style = "rs"
    bar = "bar"
  }

  override attributes overridden {
    class = "oc"
    style = "os"
    baz = "baz"
  }

  attributes overridden {
    class = "errors"
    style = "errors"
    errors = "errors"
  }


  template htmlElementNoAttributeCollections(){ preventInline()
    <div class="a" style="b" blub=c() all attributes>elements</div>
  }
  test{
    var source := rendertemplate(htmlElementNoAttributeCollections());
    log(source);
    assert(source.contains("blub=\"c\""));
    assert(source.contains("class=\"a\""));
    assert(source.contains("style=\"b\""));
  }


  template callTemplateNoAttributeCollections(){
    htmlElementNoAttributeCollections()[class="d", style="e", foo="f", all attributes]{ elements }
  }
  test{
    var source := rendertemplate(callTemplateNoAttributeCollections());
    log(source);
    assert(source.contains("blub=\"c\""));
    assert(source.contains("foo=\"f\""));
    assert(source.contains("class=\"a d\""));
    assert(source.contains("style=\"b e\""));
  }


  template htmlElement(){ preventInline()
    <div class=a() style="b" blub=c() regular attributes overridden attributes all attributes>elements</div>
  }
  test{
    var source := rendertemplate(htmlElement());
    log(source);
    assert(source.contains("class=\"a rc oc\""));
    assert(source.contains("style=\"b rs os\""));
    assert(source.contains("blub=\"c\""));
    assert(source.contains("bar=\"bar\""));
    assert(source.contains("baz=\"baz\""));
  }


  // multiple includes of the same attribute collection repeat the values, could change semantics to include an attribute collection only once
  template callTemplate(){
    htmlElement()[class=d(), style="e", foo="f", regular attributes, overridden attributes, all attributes]{ elements }
  }
  test{
    var source := rendertemplate(callTemplate());
    log(source);
    assert(source.contains("class=\"rc oc a rc oc d\""));
    assert(source.contains("style=\"rs os b rs os e\""));
    assert(source.contains("blub=\"c\""));
    assert(source.contains("bar=\"bar\""));
    assert(source.contains("baz=\"baz\""));
  }


  template htmlElementSelection(){ preventInline()
    <div class=a() style="b" blub=c()
    regular attributes
    overridden attributes
    all attributes except ["class", "foo"]
    attributes "foo"
    dummyclass=attribute("class")
    ignore default class
    >elements</div>
  }
  test{
    var source := rendertemplate(htmlElementSelection());
    log(source);
    assert(source.contains("class=\"a\""));
    assert(source.contains("style=\"b rs os\""));
    assert(source.contains("blub=\"c\""));
    assert(source.contains("bar=\"bar\""));
    assert(source.contains("baz=\"baz\""));
    assert(source.contains("foo=\"\""));
    assert(source.contains("dummyclass=\"\""));
  }


  template callTemplateSelection(){
    htmlElementSelection()[class=d(), style="e", foo="f", ignore default style]{ elements }
  }
  test{
    var source := rendertemplate(callTemplateSelection());
    log(source);
    assert(source.contains("class=\"a\""));
    assert(source.contains("style=\"b\""));
    assert(source.contains("blub=\"c\""));
    assert(source.contains("bar=\"bar\""));
    assert(source.contains("baz=\"baz\""));
    assert(source.contains("foo=\"f\""));
    assert(source.contains("dummyclass=\"d\""));
  }


  template noEmptyClassStyleAttributes(){
    div
    <div></div>
    navigate root(){}
    list{}
    var i := 0
    form{
      input(i)
      submit action{} {}
      submitlink action{} {}
    }
    noEmptyClassStyleAttributesHelper
  }
  template noEmptyClassStyleAttributesHelper(){
    <span all attributes></span>
  }
  test{
    var source := rendertemplate(noEmptyClassStyleAttributes());
    log(source);
    assert(!source.contains("class=\"\""));
    assert(!source.contains("style=\"\""));
  }


  page root(){}

  function a(): String{ return "a"; }
  function b(): String{ return "b"; }
  function c(): String{ return "c"; }
  function d(): String{ return "d"; }

  template preventInline(){
    var i := 0
    if(i>0){ input(i) }
  }
