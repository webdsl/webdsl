application native_function

native function sayHello(to : String) : String;
native function sayHello(from : String, to : String) : String;

define page root() {
  var name : String := "WebDSL user";
  output(sayHello(name))
  output(sayHello(name,  name))
}
