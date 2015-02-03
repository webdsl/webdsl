application email

  entity EmailHolder {
    e1 :: Email (not empty)
    e2 :: Email
  }

  var eh := EmailHolder{ e1 := "" e2 := "" }

  define page root() {
    form {
      label("e1 (not empty): "){
        input(eh.e1)
      }
      label("e2: "){
        input(eh.e2)
      }
      submit("Save", action{})
    }
  }

  test emailaddressrequired {
    var d : WebDriver := getHtmlUnitDriver();
    d.get(navigate(root()));
    d.getSubmit().click();
    var list := /required/.split(d.getPageSource());
    assert(list.length == 2, "expected one occurence of \"required\"");
  }
