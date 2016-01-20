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
    assert(/class=\"((a|d)\s?){2}\"/.find(source));
    assert(source.contains("style=\"b e\""));
  }


  template htmlElement(){ preventInline()
    <div class=a() style="b" blub=c() regular attributes overridden attributes all attributes>elements</div>
  }
  test{
    var source := rendertemplate(htmlElement());
    log(source);
    assert(/class=\"((a|rc|oc)\s?){3}\"/.find(source));
    assert(/style=\"((b|rs|os)\s?){3}\"/.find(source));
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
    assert(/class=\"((rc|oc|a|rc|oc|d)\s?){6}\"/.find(source));
    assert(/style=\"((rs|os|b|rs|os|e)\s?){6}\"/.find(source));
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
    assert(/style=\"((b|rs|os)\s?){3}\"/.find(source));
    assert(source.contains("blub=\"c\""));
    assert(source.contains("bar=\"bar\""));
    assert(source.contains("baz=\"baz\""));
    assert(source.contains("dummyclass=\"\""));
  }


  template callTemplateSelection(){
    htmlElementSelection()[class=d(), style="e", foo="f", ignore default style]{ elements }
  }
  test{
    var source := rendertemplate(callTemplateSelection());
    log(source);
    assert(source.contains("class=\"a\""));
    assert(source.contains("style=\"b e\""));
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


  template templatesInCodeGenerator(){ preventInline()
    form[class="c-form", style="s-form", foo="f-form", all attributes]{
      downloadlink action{} [class="c-downloadlink", style="s-downloadlink", foo="f-downloadlink", all attributes, onmouseup=action{}] {"123"}
      outputimage action{} [class="c-outputimage", style="s-outputimage", foo="f-outputimage", all attributes, onmouseup=action{}] {"123"}
      submit action{} [class="c-submit", style="s-submit", foo="f-submit", all attributes, onmouseup=action{}] {"123"}
      submit action{} [ajax, class="c-submitajax", style="s-submitajax", foo="f-submitajax", all attributes, onmouseup=action{}] {"123"}
      submitlink action{} [class="c-submitlink", style="s-submitlink", foo="f-submitlink", all attributes, onmouseup=action{}] {"123"}
      submitlink action{} [ajax, class="c-submitlinkajax", style="s-submitlinkajax", foo="f-submitlinkajax", all attributes, onmouseup=action{}] {"123"}
    }
    captcha[class="c-captcha", style="s-captcha", foo="f-captcha", all attributes, onmouseup=action{}]
    section[class="c-sec1", style="s-sec1", foo="f-sec1", all attributes, onmouseup=action{}]{
      section[class="c-sec2", style="s-sec2", foo="f-sec2", all attributes, onmouseup=action{}]{
        header[class="c-header", style="s-header", foo="f-header", all attributes, onmouseup=action{}]{"123"}}}
    var s := "url"
    image(s)[class="c-image", style="s-image", foo="f-image", all attributes, onmouseup=action{}]
    image("test")[class="c-image-string", style="s-image-string", foo="f-image-string", all attributes, onmouseup=action{}]
    image("http://webdsl.org")[class="c-image-abs-url", style="s-image-abs-url", foo="f-image-abs-url", all attributes, onmouseup=action{}]
    <script class="c-script" style="s-script" foo="f-script" all attributes></script>	
    list[class="c-list", style="s-list", foo="f-list", all attributes, onmouseup=action{}]{
      listitem[class="c-listitem", style="s-listitem", foo="f-listitem", all attributes, onmouseup=action{}]{"123"}
    }
    navigate url("root")[class="c-navurl", style="s-navurl", foo="f-navurl", all attributes, onmouseup=action{}]{"123"}
    navigate root()[class="c-nav", style="s-nav", foo="f-nav", all attributes, onmouseup=action{}]{"123"}
    navigatebutton(root(),"123")[class="c-navbutton", style="s-navbutton", foo="f-navbutton", all attributes, onmouseup=action{}]
    navigatebutton(url("root"),"123")[class="c-navbuttonurl", style="s-navbuttonurl", foo="f-navbuttonurl", all attributes, onmouseup=action{}]
  
    block[class="10", style="11"]{
      block("20")[class="21", style="22"]{
        "30"    	
      }
    }
  }
  test{
    var source := rendertemplate(templatesInCodeGenerator());
    log(source);

    assert(source.contains("foo=\"f-form\""));
    assert(source.contains("class=\"c-form\""));
    assert(source.contains("style=\"s-form\""));

    assert(source.contains("foo=\"f-downloadlink\""));
    assert(/class=\"((c-downloadlink|downloadlink)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-downloadlink\""));

    assert(source.contains("foo=\"f-outputimage\""));
    assert(/class=\"((c-outputimage|outputimage)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-outputimage\""));

    assert(source.contains("foo=\"f-submit\""));
    assert(/class=\"((c-submit|button)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-submit\""));

    assert(source.contains("foo=\"f-submitajax\""));
    assert(/class=\"((c-submitajax|button)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-submitajax\""));

    assert(source.contains("foo=\"f-submitlink\""));
    assert(source.contains("class=\"c-submitlink\""));
    assert(source.contains("style=\"s-submitlink\""));

    assert(source.contains("foo=\"f-submitlinkajax\""));
    assert(source.contains("class=\"c-submitlinkajax\""));
    assert(source.contains("style=\"s-submitlinkajax\""));
    
    assert(source.contains("foo=\"f-captcha\""));
    assert(source.contains("class=\"c-captcha\""));
    assert(source.contains("style=\"s-captcha\""));
    
    assert(source.contains("foo=\"f-sec1\""));
    assert(/class=\"((section|section1|c-sec1)\s?){3}\"/.find(source));
    assert(source.contains("style=\"s-sec1\""));
    
    assert(source.contains("foo=\"f-sec2\""));
    assert(/class=\"((section|section2|c-sec2)\s?){3}\"/.find(source));
    assert(source.contains("style=\"s-sec2\""));
    
    assert(source.contains("foo=\"f-header\""));
    assert(/class=\"((header|section2|c-header)\s?){3}\"/.find(source));
    assert(source.contains("style=\"s-header\""));
    
    assert(source.contains("foo=\"f-image\""));
    assert(source.contains("class=\"c-image\""));
    assert(source.contains("style=\"s-image\""));
    
    assert(source.contains("foo=\"f-image-string\""));
    assert(source.contains("class=\"c-image-string\""));
    assert(source.contains("style=\"s-image-string\""));
    
    assert(source.contains("foo=\"f-image-abs-url\""));
    assert(source.contains("class=\"c-image-abs-url\""));
    assert(source.contains("style=\"s-image-abs-url\""));

    assert(source.contains("foo=\"f-script\""));
    assert(source.contains("class=\"c-script\""));
    assert(source.contains("style=\"s-script\""));

    assert(source.contains("foo=\"f-list\""));
    assert(/class=\"((block|c-list)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-list\""));

    assert(source.contains("foo=\"f-listitem\""));
    assert(/class=\"((block|c-listitem)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-listitem\""));

    assert(source.contains("foo=\"f-navurl\""));
    assert(/class=\"((c-navurl|navigate)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-navurl\""));
    
    assert(source.contains("foo=\"f-nav\""));
    assert(/class=\"((c-nav|navigate)\s?){2}\"/.find(source));
    assert(source.contains("style=\"s-nav\""));

    assert(source.contains("foo=\"f-navbuttonurl\""));
    assert(source.contains("class=\"c-navbuttonurl\""));
    assert(source.contains("style=\"s-navbuttonurl\""));
    
    assert(source.contains("foo=\"f-navbutton\""));
    assert(source.contains("class=\"c-navbutton\""));
    assert(source.contains("style=\"s-navbutton\""));
    
    assert(source.contains("<div class=\"block 10\" style=\"11\"><div class=\"block 20 21\" style=\"22\">30</div></div>"));
  }


  template callTemplateWithCodeGenTemplates(){
     templatesInCodeGenerator[class="classtest",style="styletest",bar="q",regular attributes,overridden attributes]
  }
  test{
    var source := rendertemplate(callTemplateWithCodeGenTemplates());
    log(source);
    assert(source.split("classtest").length == 18);
    assert(source.split("styletest").length == 18);
    assert(source.split("bar=\"q\"").length == 18);
    assert(/class=\"((rc|oc|c-nav|classtest|navigate)\s?){5}\"/.find(source));
  }

  
  attributes included {
    class = "included-class"
    style = "included-style"
    included = "included"
    regular attributes ignore class style
  }
  attributes includer {
    class = "includer-class"
    style = "includer-style"
    includer = "includer"
    //test with multiple includes
    included attributes
    overridden attributes
  }
  template attrincludes(){
    <div includer attributes>"1"</div>
    block[includer attributes]{"2"}
    navigate root() [includer attributes] {"3"}
  }
  test{
    var source := rendertemplate(attrincludes());
    log(source);
    assert(source.split(" included=\"included\"").length == 4);
    assert(source.split(" includer=\"includer\"").length == 4);
    assert(source.split(" bar=\"bar\"").length == 4);
    assert(source.split(" baz=\"baz\"").length == 4);
    assert(source.split(" style=\"os included-style includer-style\"").length == 4);
    assert(/class=\"((oc|included-class|includer-class|navigate)\s?){3}\"/.find(source));
  }
  
  entity TestEntity{}
  var testa := TestEntity{}
  var testb := TestEntity{}
  var testc := TestEntity{}
  template testInputSet(){
    var set := Set<TestEntity>()
    form{
      input(set)[class = "customclass"]
    }
    
    attrSelect[class="attrSelectAddedClass"]
  }
  template attrSelect(){
  	<div class="attrSelectClassTest" all attributes except "foo" all attributes except ["foo"] attributes "class" attributes ["class"] all attributes regular attributes>
  	</div>
  }
  test{
    var source := rendertemplate(testInputSet());
    log(source);
    assert(/class=\"((checkbox-set|customclass)\s?){2}\"/.find(source));
    assert(source.split("checkbox-set-element").length == 4);
    assert(/class=\"((attrSelectClassTest|attrSelectAddedClass|attrSelectAddedClass|attrSelectAddedClass|attrSelectAddedClass|attrSelectAddedClass|rc)\s?){7}\"/.find(source));
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
