//Cannot override the builtin property 'id'
//Cannot override the builtin property 'version'
//Cannot use the reserved property name 'class'
//Cannot override the builtin property 'created'
//Cannot override the builtin property 'modified'
//Reference type is not allowed
//#15 Expected: collection of Entity
//Type 'Null' is not allowed
//Type 'Void' is not allowed
//Type 'Entity' is not allowed
//#2 Expected: primitive or Entity type

application test

entity Test {
  id       : String
  version  : String
  class    : String  // would cause name clash with java's getClass()
  created  : String
  modified : String

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

  // allow native class for derived property
  ratio : Double := Double(0.0)
}

define page root() { }
