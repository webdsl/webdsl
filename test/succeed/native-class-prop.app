application nativeclassprop

  native class nativejava.TestProp as TestProp {
    constructor()
    getProp() : String 
    getSelf() : TestProp
  }

  define page root() {
  
    var o : TestProp := TestProp()
	output(o.getSelf().getSelf().getProp())
        
  }
