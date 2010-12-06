application exampleapp

define page root(){
  break()[class="wrapper-class-attribute", style="background-color:yellow;"]
  div()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  container()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  fieldset("legend")[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  div()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  par()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  pre()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  spacer()[class="wrapper-class-attribute", style="background-color:yellow;"]
}

test builtintemplates {
  var d : WebDriver := FirefoxDriver();
  d.get(navigate(root()));
  assert(d.getPageSource().split("wrapper-class-attribute").length == 9);
  assert(d.getPageSource().split("background-color").length == 9);
  assert(d.getPageSource().split("elements-inside").length == 7);
  d.close();
}
