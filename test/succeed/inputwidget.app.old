application inputwidget

section pages

define inputtemplate mythingy(val: String, name: String) {
  spacer
  "val: " output(val)
  "name: " output(name)
  <input name=name type="text" value=val />
  spacer
}

define page aninputtest(s: String) {
  "current value: " output(s)
  spacer
  form {
    "new value: " mythingy(s)
    action("go",save_s(s))
  }
  action save_s(astring: String) {
    return aninputtest(astring);
  }
}

define page root() {
  navigate(aninputtest("some value")) { "Test input widget" }
}