application templateoverloading


entity SuperClass{
  name :: String
}

entity SubClassOne : SuperClass{}
entity SubClassTwo : SuperClass{}

entity SubClassThree : SubClassOne{}


var super1 := SuperClass{ name := "super1"};
var super2 := SuperClass{ name := "super2"};
var subclass1 := SubClassOne{name := "sub1"};
var subclass2 := SubClassTwo{name := "sub2"};
var subclass3 := SubClassThree{name := "sub3"};

define page root(){
  var super3 := SuperClass{name := "super"};
  var sub1 := SubClassOne{name := "sub1"};
  var sub2 := SubClassTwo{name := "sub2"};

  temp(4)
  temp("bla")
  temp(super3)
  temp(sub1)
  temp(sub2)
  
  templ(super3)
  templ(sub1)
  templ(sub2)
  
  temp(super3,sub2)
  temp(sub1,super3)
  temp(sub1,sub2)
  
  " super: " output(super1)
  " sub1: " output(subclass1)
  //should use subclassone output as well:
  " sub3: " output(subclass3)
  
  break
  "genericsorts"
  break
  templist([super3])
  //should be allowed?: pass collection of subtypes
  //templist([sub1])

}

define page superClass(s:SuperClass){
  output(s.name)
}

define temp(i:Int){" 1 "}

define temp(s:String){" 2 "}

define temp(s:SuperClass){ " 3 "}
define temp(s:SubClassOne){ " 4 "}
define temp(s:SubClassTwo){ " 5 "}

define templ(s:SuperClass){" 6/8 "}
define templ(s:SubClassOne){" 7 "}

define temp(s:SuperClass,s1:SuperClass){ " 9 "}
define temp(s:SubClassOne,s1:SuperClass){ " 10 "}
define temp(s:SubClassOne,s1:SubClassTwo){ " 11 "}

define output(s:SubClassOne){
  output("subclassone: "+s.name)
}

define templist(l: List<SuperClass>){
  "list"
}
