application thiscalls

  native class nativejava.TestProp as TestProp {
    constructor()
    getProp() : String
  }

  function funcGlob() { }

  entity A {
  	function funcA1() {
  		// Call to same entity
  		funcA2();
  		// Call to self
  		funcA1();
  	}
  	function funcA2() { }
  }
  
  entity B : A {
  	function funcB() {
  		// Super call
  		funcA1();
  		// Global call
  		funcGlob();
  	}
  }
  
  extend entity B {
  	function extFunction(x : Int) {
  	}
  	function extFunction2() {
  		extFunction(3);
  		funcA1();
  		funcGlob();
  	}
  }
  
  define page root(){
  
  	action testAction() {
  		// Page call
  		return root();
  	}
  	
  	action testAction2() {
  		// Action call
  		// return testAction();
  	}
  
  }
  
  
  