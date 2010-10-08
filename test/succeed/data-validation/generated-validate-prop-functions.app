application registerexample

  entity User {
    s :: String (validate(s.length() > 5,"too short"))
  }

  define page root(){
  }

  test datavalidation {
    var u := User{};
    var val := u.validateS();
    assert(val.exceptions.length==1);
  }
    
  test internalfunction{
    var u := User{};
    var v := ValidationExceptionMultiple{};
    u.validateS_internal(v);
    assert(v.exceptions.length==1);
  }

  test validatesave{
    var u := User{};
    assert(u.validateSave().exceptions.length==1);
  }
