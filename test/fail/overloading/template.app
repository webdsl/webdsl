//conflicting signatures

application templateoverloading

entity SuperClass{
  name :: String
}

entity SubClassOne : SuperClass{}
entity SubClassTwo : SuperClass{}

entity SubClassThree : SubClassOne{}

define page home(){
  var super := SuperClass{name := "super"};
  var sub1 := SubClassOne{name := "sub1"};
  var sub2 := SubClassTwo{name := "sub2"};

  temp(sub1,sub2)
}

define temp(s1:SuperClass,s2:SuperClass){" 1 "}
define temp(s:SubClassOne,s1:SuperClass){" 2 "}
define temp(s1:SuperClass,s1:SubClassTwo){" 3 "}
