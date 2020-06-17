//#2 Cannot override the builtin property 'id'
//#2 Cannot override the builtin property 'version'
//#2 Cannot use the reserved property name 'class'
//#2 Cannot override the builtin property 'created'
//#2 Cannot override the builtin property 'modified'
//#2 Property name is not allowed to overlap with entity name
//#12 is defined multiple times
//Reference type is not allowed
//#15 Expected: collection of Entity
//Type 'Null' is not allowed
//Type 'Void' is not allowed
//Type 'Entity' is not allowed
//#2 Expected: primitive or Entity type
//#1 Type not defined

application test

entity Test {
  id       : String
  version  : String
  class    : String  // would cause name clash with java's getClass()
  created  : String
  modified : String
  Test     : String

  ref : ref Test

  sl : [String]
  ss : {String}

  n  : Null
  nl : [Null]
  ns : {Null}
  v  : Void
  vl : [Void]
  vs : {Void}
  f  : Facet
  fl : [Facet]
  fs : {Facet}
  e  : Entity
  el : [Entity]
  es : {Entity}
  d  : Double
  dl : [Double]
  ds : {Double}

  ell : [[Test]]
  ess : {{Test}}
  elsls : [{[{Test}]}]

  // allow any valid type for derived property, which is transformed to a function
  r : Double := Double(0.0)
  r1 :: Double := Double(0.0)
  dn -> Entity := this as Entity

  id       : Bool := true
  version  : Bool := true
  class    : Bool := true
  created  : Bool := true
  modified : Bool := true
  Test     : Bool := true

  error : Unknown := "1"

  // transient properties also allow any valid type
  et : Entity (transient)
  et1 -> Entity (transient)
  dt : Double (transient)
}

define page root() { }
