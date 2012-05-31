application test

  session settings{
      someValue :: String (default="sessionTest")
  }

  entity Role{
      role :: String (default="entTest")
  }

  define page root(){
      var e : Role;
      init{
          e := Role{};
          e.save();
      }
    output(settings.someValue)
    output(e.role)
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));

    var pagesource := d.getPageSource();
    assert(pagesource.contains("sessionTest"), "Default value for session entity prop 'settings.someValue' not loaded");
    assert(pagesource.contains("entTest"), "Default value for entity prop 'Role.role' not loaded");
  }
