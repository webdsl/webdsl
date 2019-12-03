application test

section datamodel

  entity DateTest{
    date :: Date
    time :: Time
    datetime :: DateTime 
  }
  
  var globalDT : DateTest := DateTest{};
  
  define page root(){
    " date: " output(globalDT.date) 
    " date as time: " output(globalDT.date as Time)
    " date as datetime: " output(globalDT.date as DateTime)
    " time: " output(globalDT.time) 
    " time as date: " output(globalDT.time as Date)
    " time as datetime: " output(globalDT.time as DateTime)
    " datetime: " output(globalDT.datetime) 
    " datetime as date: " output(globalDT.datetime as Date)
    " datetime as time: " output(globalDT.datetime as Time)

    form{
      input(globalDT.date)
      input(globalDT.time)
      input(globalDT.datetime)
      
      action("save",action{})
    }
  }

  test dateConstruction{
    var d : Date := Date("22/06/1983");
    var t : Time := Time("22:08");
    var dt : DateTime := DateTime("22/06/1983 22:08");
    
    var d1 : Date := Date("12-20-1990", "MM-dd-yyyy");
    assert(d1 == Date("20/12/1990"));
    var t1 : Time := Time("59:08", "mm:H");
    assert(t1 == Time("08:59"));
    var dt1 : DateTime := DateTime("12:13 05-1994-06", "mm:H MM-yyyy-dd");
    assert(dt1 == DateTime("06/05/1994 13:12"));
  }
  
  test dateFunctions{
    var d: Date := now();
    var t: Time := now();
    var dt: DateTime := now();
    
    var d1: Date := today();
    
    var date : Date := Date("04/09/2009");
    assert(date.after(Date("01/02/1975")));
    assert((date as Time).after(DateTime("31/12/1981 23:23")));
    assert((date as DateTime).after(Date("01/02/1975")));
    
    assert(date.before(Date("01/02/2020")));
    assert((date as Time).before(Date("13/10/2010")));
    assert((date as DateTime).before(Date("01/02/2050")));
    
  }
  
  test dateConversions{
    var d : Date := Date("22/06/1983");
    assert(d as Time == DateTime("22/06/1983 00:00") as Time);
    assert(d as DateTime == DateTime("22/06/1983 00:00"));
        
    var t : Time := Time("22:08");
    assert(t as Date == DateTime("01/01/1970 22:08") as Date);
    assert(t as DateTime == DateTime("01/01/1970 22:08"));
    
    var dt : DateTime := DateTime("22/06/1983 22:08");
    assert(dt as Time == DateTime("22/06/1983 22:08") as Time);
    assert(dt as Date == DateTime("22/06/1983 22:08") as Date);
  }
  
  test dateDefault {
    var test : DateTest := DateTest{};
    assert(test.date == null);  
    assert(test.time == null);  
    assert(test.datetime == null);  
  }
  
  test dateAdd {
    var test : DateTest := DateTest{};
    test.date := Date("01/02/2020");  
    assert(test.date.addDays(1).addMonths(1).addYears(1) == Date("02/03/2021")); 

    test.time := Time("22:08"); 
    assert(test.time.addHours(1).addMinutes(1).addSeconds(1) == Time("23:09").addSeconds(1));
     
    test.datetime := DateTime("22/06/1983 22:08");
    assert(test.datetime.addDays(-1).addMonths(-1).addYears(-1).addHours(-1).addMinutes(-1).addSeconds(-1) == DateTime("21/05/1982 21:06").addSeconds(59));
  }
  
