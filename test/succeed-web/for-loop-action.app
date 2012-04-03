// http://yellowgrass.org/issue/WebDSL/368

application exampleapp

  define page root(){
    var conv := c1
    for(tag : Tag in conv.tags order by tag.name) {
      output(tag.name)
      submitlink removeTag(tag) [class="testbutton"] { "x" }
    }
    action removeTag(tag : Tag) {
      conv.tags.remove(tag);
    }
  }

  entity Conversation{
    tags -> Set<Tag> //(inverse=Tag.conversations)
  }
  entity Tag{
    name :: String
    //conversations -> Set<Conversation>
  }

  var c1 := Conversation{}
  
  init {
    var t1 := Tag{ name := "tag1" };
    t1.save();
    var t2 := Tag{ name := "tag2"};
    t2.save();
    var t3 := Tag{ name := "tag3"};
    t3.save();
    c1.tags := {t1,t2,t3};
  }
    
  test builtintemplates {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var buttons := d.findElements(SelectBy.className("testbutton"));
    assert(buttons.length == 3);
    buttons[2].click();
    assert(!d.getPageSource().contains("tag3"));
  }
