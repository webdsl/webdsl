application test

section datamodel

  entity User{
    name     :: String
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
  
  define page user(u:User){
    output(u.name)
  }

  define page home(){
    for(u:User){
      " name: " output(u.name)
      " i: " output(u.ival)
      " f: " output(u.fval)
    }    
    break
    "count(*): " output(testInt(select count(*) from User as u))
    break
    "count(u): " output(testInt(select count(u) from User as u))
    break
    "max i: " output(testInt(select max(u.ival) from User as u))
    break
    "max f: " output(testFloat(select max(u.fval) from User as u))
    break
    "min i: " output(testInt(select min(u.ival) from User as u))
    break
    "min f: " output(testFloat(select min(u.fval) from User as u))
    break
    "avg i: " output(select avg(u.ival) from User as u)
    break
    "avg f: " output(select avg(u.fval) from User as u)
    break
    "sum i: " output(testInt(select sum(u.ival) from User as u))
    break
    "sum f: " output(testFloat(select sum(u.fval) from User as u))
  }
  
  function testInt(i:Int):Int{
    return i;
  }
  
  function testFloat(i:Float):Float{
    return i;
  }
  
