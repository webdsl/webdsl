//Template with signature
//not defined

application templateoverloading

entity SuperClass{
  name :: String
}

entity SubClassOne : SuperClass{}
entity SubClassTwo : SuperClass{}

entity SubClassThree : SubClassOne{}

define page root(){
  var super := SuperClass{name := "super"};
  var sub1 := SubClassOne{name := "sub1"};
  var sub2 := SubClassTwo{name := "sub2"};

  temp({super}) //set not allowed for list arg
}

define temp(s1:List<SuperClass>){" 1 "}
