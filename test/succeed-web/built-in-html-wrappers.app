application exampleapp

define page root(){
  break()[class="wrapper-class-attribute", style="background-color:yellow;"]
  div()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  container()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  fieldset("legend")[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  par()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  pre()[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
  spacer()[class="wrapper-class-attribute", style="background-color:yellow;"]
  table()[class="wrapper-class-attribute", style="background-color:yellow;"]{ 
    row()[class="wrapper-class-attribute", style="background-color:yellow;"]{
      column()[class="wrapper-class-attribute", style="background-color:yellow;"]{
        "elements-inside"
      }
    }
  }
  group("bla")[class="wrapper-class-attribute", style="background-color:yellow;"]{
    groupitem()[class="wrapper-class-attribute", style="background-color:yellow;"]{
      labelcolumns("")[class="wrapper-class-attribute", style="background-color:yellow;"]{ "elements-inside" }
    }
  }
}

test builtintemplates {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  assert(d.getPageSource().split("wrapper-class-attribute").length == 14);
  assert(d.getPageSource().split("background-color").length == 14);
  assert(d.getPageSource().split("elements-inside").length == 8);
}
