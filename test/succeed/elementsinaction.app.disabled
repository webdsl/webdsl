//THIS TEST TESTS THE POSSIBLITY TO REFER TO ELEMENTS() inside an action in order to implement lazy loading tabpages. 
//The crucial line is line 65 
application elementsinaction

section pages


define page root() {
  tabs {
    tab("Cool, Ajax widgets and template arguments!", true, true){
     "empty"
    }
    tab("Hansel and Gretel",false, true) {
      "Hard by a great forest dwelt a poor wood-cutter with his wife and his two children. The boy was called Hansel and the girl Gretel. He had little to bite and to break, and once when great dearth fell on the land, he could no longer procure even daily bread."
    }
    lazytab("The Three Green Twigs", false, false) {
      "There was once upon a time a hermit who lived in a forest at the foot of a mountain, and passed his time in prayer and good works, and every evening he carried, to the glory of God, two pails of water up the mountain."
    }   
  }

} 


define template tabs() {
  output(attribute("kop", "niet gespecificeerd"))
      <script>
        loadDojo(false, function() {
          dojo.require("dijit.dijit");
          dojo.require("dijit.layout.TabContainer");
          dojo.require("dijit.layout.ContentPane");
          dojo.require("dojo.parser");
          dojo.require("dijit.form.Button");
          dojo.require("dijit._Widget");
          dojo.require("dijit._base.place");
        });
      </script>
      <div id="mainTabContainer" dojoType="dijit.layout.TabContainer"
        class="tundra" style="width:600px;height:400px">
      elements()
      </div>
}

define no-span template tab(title:String, selected: Bool, closable: Bool) {
      <div dojoType="dijit.layout.ContentPane" title=(title) selected=(selected) closable=(closable)>
        elements()
      </div>
}

define no-span template lazytab(title:String, selected: Bool, closable: Bool) {
  <div dojoType="dijit.layout.ContentPane" title=(title) selected=(selected) closable=(closable)>
    <script>
      function lazyload(tab) {
        elems = tab.domNode.getElementsByTagName('input');
        if (elems[1] && elems[1].id == 'loader') {
          elems[1].onclick();
        }
      }
    </script>
    <script type="dojo/method" event="onShow">
      "lazyload(this);"
    </script>
    placeholder tabcontents {
      form{
        action(">",action{
          replace(tabcontents,template { elements() } ); //THIS IS WHAT THIS TEST IS ABOUT!
        })[id:=loader]
        "loading..."
      }
    }
  </div>       
} 