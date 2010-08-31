application test

  entity A {
    prop ::String
    changed :: Bool
    extend function setProp(s:String){
      changed := true;
    }
  }
  
  entity B : A {
    function init(){
      //this.prop := "init";  //works, triggers extension
      prop := "init";  //doesn't work
    }
  }

  define page root(){

  }

  test setterextension {
    var b := B{};
    b.init();
    assert(b.changed);
  }