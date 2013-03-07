application test

  var t1 := TestInput{}

  entity TestInput{
    i : Int
    b: Bool (validate(b,"must be checked"), default=true)
  }

  define page root(){
    inputswithajax(t1)
  }

  define inputswithajax(t:TestInput){
    form{
      inputajaxtestversionint(t.i)[class="test-int", onkeyup=test(""+t.i)]
      inputajaxtestversionbool(t.b)[class="test-bool", onchange=test("checkbox changed")]

      //inputajaxtestversion(t.i)[class="test1", onkeyup=action{ replace("testplaceholder",show(""+t.i1)); }]
      //without ignore-validation causes validation failure and full form rerender

      submit action{}[class="button"] {"save"}
    }
    placeholder "testplaceholder" {}
    action ignore-validation test(s:String){
      replace("testplaceholder",show(s));
      rollback();
      // if no rollback: can get transaction conflict when executing multiple requests, because argument is persisted (global variable t1).
      // TODO transaction failure causes complete form rerender currently, should look into handling that with a different effect (such as error message at the the top/popup)
    }
  }

  ajaxtemplate show(s:String){
    output(s)
  }

  test inputajaxtests{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    log(d.getPageSource());
    var testint := d.findElement(SelectBy.className("test-int"));
    testint.clear();
    testint.sendKeys("12345");
    sleep(2000);
    assert(d.getPageSource().split("testplaceholder")[1].contains("12345"));
    testint.sendKeys("a");
    sleep(2000);
    assert(d.getPageSource().contains("valid number"));

    var testbool := d.findElement(SelectBy.className("test-bool"));
    testbool.click();
    sleep(2000);
    assert(d.getPageSource().contains("must be checked"));
    assert(d.getPageSource().contains("checkbox changed"));
  }

  define inputajaxtestversionint(i:Ref<Int>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    //changed:
    inputIntInternal(i,tname)[onkeyup=validator();""+attribute("onkeyup"), all attributes except "onkeyup"]
    //
    validate{ getPage().enterLabelContext(tname); }
    elements()
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := checkIntWellformedness(req);
      if(errors==null){
        errors := i.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := checkIntWellformedness(req);
      if(errors==null){
        errors := i.getValidationErrors();
        getPage().enterLabelContext(tname);
        validatetemplate(elements());
        getPage().leaveLabelContext();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      }
      rollback();
    }
  }

  define inputajaxtestversionbool(b:Ref<Bool>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    // changed:
    inputBoolInternal(b,tname)[onchange=validator();""+attribute("onchange"), all attributes except "onchange"]
    //
    validate{ getPage().enterLabelContext(tname); }
    elements()
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := b.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := b.getValidationErrors();
      getPage().enterLabelContext(tname);
      validatetemplate(elements());
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      }
      rollback();
    }
  }
