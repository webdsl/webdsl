application test

  entity Testinputs{
    list -> List<SomeEntity>
    set -> Set<SomeEntity>
    ent -> SomeEntity (not null)
    list1 -> List<SomeEntity> (allowed=[s_3,s_4])
    set1 -> Set<SomeEntity>(allowed=[s_3,s_4])
    ent1 -> SomeEntity (allowed=[s_3,s_4])
  }
  
  var t_1 := Testinputs{}

  entity SomeEntity{
    name :: String
  }
  
  var s_1 := SomeEntity { name := "SomeEntity1" }
  var s_2 := SomeEntity { name := "SomeEntity2" }
  var s_3 := SomeEntity { name := "SomeEntity3" }
  var s_4 := SomeEntity { name := "SomeEntity4" }
  define inputajax1(ent : Ref<List<Entity>>){
    init{
      log(ent.getAllowed());
    }
    inputajax(ent,ent.getAllowed())[all attributes]{elements()}
  } 
  define page root(){
    navigate setvariants(){"set variants"}
    navigate entvariants(){"ent variants"}
    navigate listvariants(){"list variants"}
    form{
      inputajax1(t_1.list)
      inputajax(t_1.set)
      inputajax(t_1.ent)
      submit action{} {"save"}
    }
    <br/>
    form{
      inputajax(t_1.list1)
      inputajax(t_1.set1)
      inputajax(t_1.ent1)
      submit action{} {"save"}
    }
    <br/>
    output(t_1.list)
    output(t_1.set)
    output(t_1.ent)
    output(t_1.list1)
    output(t_1.set1)
    output(t_1.ent1)
    //output(t_1.list)
    //output(t_1.set)
    //output(from SomeEntity as ent order by ent.name)
    //output([s|s:SomeEntity in (from SomeEntity) order by s.name])
  }
  
  define page setvariants(){
    var t := t_1
    var options := [s_3,s_4]

    form{ input(t.set1) submit action{} {"save"}	}
    form{ select(t.set1) submit action{} {"save"}	}
    form{ selectcheckbox(t.set1) submit action{} {"save"}	}
    form{ inputajax(t.set1) submit action{} {"save"}	}
    form{ selectajax(t.set1) submit action{} {"save"}	}
    form{ selectcheckboxajax(t.set1) submit action{} {"save"}	}

    form{ input(t.set1,options) submit action{} {"save"}	}
    form{ select(t.set1,options) submit action{} {"save"}	}
    form{ selectcheckbox(t.set1,options) submit action{} {"save"}	}
    form{ inputajax(t.set1,options) submit action{} {"save"}	}
    form{ selectajax(t.set1,options) submit action{} {"save"}	}
    form{ selectcheckboxajax(t.set1,options) submit action{} {"save"}	}
    
  }
  
  define page entvariants(){
    var t := t_1
    var options := [s_3,s_4]

    form{ input(t.ent1) submit action{} {"save"}	}
    form{ select(t.ent1) submit action{} {"save"}	}
    form{ radio(t.ent1) submit action{} {"save"}	}
    form{ inputajax(t.ent1) submit action{} {"save"}	}
    form{ selectajax(t.ent1) submit action{} {"save"}	}
    form{ radioajax(t.ent1) submit action{} {"save"}	}

    form{ input(t.ent1,options) submit action{} {"save"}	}
    form{ select(t.ent1,options) submit action{} {"save"}	}
    form{ radio(t.ent1,options) submit action{} {"save"}	}
    form{ inputajax(t.ent1,options) submit action{} {"save"}	}
    form{ selectajax(t.ent1,options) submit action{} {"save"}	}
    form{ radioajax(t.ent1,options) submit action{} {"save"}	}
    
  }
  
  define page listvariants(){
    var t := t_1
    var options := [s_3,s_4]

    form{ input(t.list1) submit action{} {"save"}	}
    form{ inputajax(t.list1) submit action{} {"save"}	}

    form{ input(t.list1,options) submit action{} {"save"}	}
    form{ inputajax(t.list1,options) submit action{} {"save"}	}

  }
 /*
  define page root(){
    form{
      input(t_1.list)
      input(t_1.set)
      input(t_1.ent)
      submit action{} {"save"}
    }
    <br/>
    form{
      select(t_1.set from [s_2,s_1])
      select(t_1.list from [s_2,s_1])
      select(t_1.ent from [s_2,s_1])
      submit action{} {"save"}
    }
    <br/>
    form{
      input(t_1.list)
      input(t_1.set)
      input(t_1.ent)
      submit action{} {"save"}
    }
    <br/>
    output(t_1.list)
    output(t_1.set)
    output(t_1.ent)
    //output(t_1.list)
    //output(t_1.set)
    //output(from SomeEntity as ent order by ent.name)
    //output([s|s:SomeEntity in (from SomeEntity) order by s.name])
  }
*/

  test allowedselects{
    var test := Testinputs{};
    assert(s_3 in test.allowedList1());
    assert(s_4 in test.allowedList1());
    assert(!(s_1 in test.allowedList1()));
    assert(!(s_2 in test.allowedList1()));
    
    assert(s_3 in test.allowedSet1());
    assert(s_4 in test.allowedSet1());
    assert(!(s_1 in test.allowedSet1()));
    assert(!(s_2 in test.allowedSet1()));
    
    assert(s_3 in test.allowedSet1());
    assert(s_4 in test.allowedSet1());
    assert(!(s_1 in test.allowedSet1()));
    assert(!(s_2 in test.allowedSet1()));
    
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(setvariants()));
    assert(d.getPageSource().split("SomeEntity3").length==13);
    assert(d.getPageSource().split("SomeEntity2").length==1);

    d.get(navigate(entvariants()));
    assert(d.getPageSource().split("SomeEntity3").length==13);
    assert(d.getPageSource().split("SomeEntity2").length==1);
    
    d.get(navigate(listvariants()));
    assert(d.getPageSource().split("SomeEntity3").length==5);
    assert(d.getPageSource().split("SomeEntity2").length==1);
  }

 