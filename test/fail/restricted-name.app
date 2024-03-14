//#10 Name 'in' is not allowed
//#4 Name 'global' is not allowed
//#4 Name 'session' is not allowed

application test

page root {
  var in := "ghhfg"
  action fsdfsdf( in: String ){}
}
page a {
  var in: String := "ghhfg"
}
page b {
  var in: String
}
page c( in: String ){}
function c( in: String ){}
function d( in: String ): Bool{ return true; }
predicate e( in: String ){ true }

entity Reserved {}

var in := Reserved{}
var in: Reserved := Reserved{}

var global := Reserved{}
var global: Reserved := Reserved{}
var session := Reserved{}
var session: Reserved := Reserved{}
request var global := Reserved{}
request var global: Reserved := Reserved{}
request var session := Reserved{}
request var session: Reserved := Reserved{}
