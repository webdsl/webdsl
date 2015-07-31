//Attribute collection with name 'navigawte' not defined
//Attribute collection with name 'unknownattr' not defined
//Attribute collection with name 'foo' not defined
//Only 'class' and 'style' are implicitly combined with defaults.
//#2 Attribute collection with name 'dupl' is defined multiple times. Use 'override' modifier to replace existing attribute collections.
//#2 Attribute collection override with name 'dupl' is defined multiple times. Only one 'override' allowed.
//Attribute collection override with name 'dupl2' must override an existing definition.

application test

attributes navigate {
  class = "btn btn-default"
  style = "test"
  unknownattr attributes
  ignore foo attributes
}

attributes dupl{}
attributes dupl{}

override attributes dupl{}
override attributes dupl{}

override attributes dupl2{}

page root(){
  div[navigawte attributes]{

  }
  span[ignore default classs]{}
}