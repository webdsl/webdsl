application test

section datamodel

  entity User{
    name :: String
    ival :: Int
    fval :: Float
  }
  
  var u_1 := User{
    name:="Global1"
    ival:=2
    fval:=2.2
  }
  var u_2 := User{
    name:="Global2" 
    ival:=45
    fval:=54.67
  }
  var u_3 := User{
    name:="Global3" 
    ival:=1
    fval:=1.0
  }
  
  define page root(){
  }

  test aggregatehql {
    var intResult : Int := 3;
    var floatResult : Float;

    assert((select count(*) from User) == intResult); 
    assert((select count(u) from User as u) == intResult);    
    

    intResult := 45;
    floatResult := 54.67;
    assert((select max(ival) from User) == intResult);
    assert((select max(u.fval) from User as u) == floatResult);

    intResult := 1;
    floatResult := 1.0;
    assert((select min(ival) from User) == intResult);
    assert((select min(u.fval) from User as u) == floatResult);

    floatResult := 16.0;
    assert((select avg(ival) from User) == floatResult);
    floatResult := (u_1.fval + u_2.fval + u_3.fval) / 3.0; // Cannot put 19.29 here, because then 19.289999 == 19.29 fails
    assert((select avg(u.fval) from User as u) == floatResult);

    intResult := 48;
    floatResult := 57.87;
    assert((select sum(ival) from User) == intResult);
    assert((select sum(u.fval) from User as u) == floatResult);
  }
