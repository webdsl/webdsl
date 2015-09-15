// a null value in order by caused nullpointer exception which broke page rendering

application test

entity Value{
  int : Int
  datetime : DateTime
}

init{
  var v1 := Value{ 
    int := 0
    datetime := DateTime("15/09/2015 15:09")
  }.save();
  var v2 := Value{ 
    int := null as Int
    datetime := null as DateTime
  }.save();
  var v3 := Value{ 
    int := 1
    datetime := DateTime("15/09/2015 15:09").addHours(3)
  }.save();
  var v4 := Value{ 
    int := null as Int
    datetime := null as DateTime
  }.save();
}

page root(){
  testtemplate
}

template testtemplate(){
  for(v : Value order by v.int){ output(v.int) }
  br
  for(v : Value order by v.datetime){ output(v.datetime) }
  br
  for(i in [0,null,1,2,null] order by i asc){ output(i) }
  br
  for(i in [0,null,1,2,null] order by i desc){ output(i) }
}

test{
  var d: WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  var source := d.getPageSource();
  log(source);
  assert(source.contains("01nullnull"));
  assert(source.contains("15/09/2015 15:0915/09/2015 18:09"));
  assert(source.contains("012nullnull<br />210nullnull"));
}