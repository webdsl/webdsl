application test

  entity Testinputs{
    list -> List<SomeEntity>
    set -> Set<SomeEntity>
    ent -> SomeEntity (not null)
  }
  entity Testinputs2{
    list -> List<SomeEntity> (allowed=[s_3,s_4])
    set -> Set<SomeEntity>(allowed=[s_3,s_4])
    ent -> SomeEntity (allowed=[s_3,s_4])
  }
  
  var t_1 := Testinputs{}
  var t_2 := Testinputs2{}

  entity SomeEntity{
    name :: String
  }
  
  var s_1 := SomeEntity { name := "some entity 1" }
  var s_2 := SomeEntity { name := "some entity 2" }
  var s_3 := SomeEntity { name := "some entity 3" }
  var s_4 := SomeEntity { name := "some entity 4" }

  page root(){
    form{
      input(t_1.list)
      input(t_1.set)
      input(t_1.ent)
      submit action{} {"save"}
    }
    <br/>
    form{
      input(t_1.set, [s_2,s_1])
      input(t_1.list, [s_2,s_1])
      input(t_1.ent, [s_2,s_1])
      submit action{} {"save"}
    }/*
    <br/>
    form{
      input(t_2.list)
      input(t_2.set)
      input(t_2.ent)
      submit action{} {"save"}
    }
    <br/>*/
    output(t_1.list)
    output(t_1.set)
    output(t_1.ent)
    //output(t_1.list)
    //output(t_1.set)
    //output(from SomeEntity as ent order by ent.name)
    //output([s|s:SomeEntity in (from SomeEntity) order by s.name])
  }

  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().split("some entity 1").length == 7);
    assert(d.getPageSource().split("some entity 2").length == 7);
    assert(d.getPageSource().split("some entity 3").length == 4);
    assert(d.getPageSource().split("some entity 4").length == 4);
  }