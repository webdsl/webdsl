application testapp

//http://yellowgrass.org/issue/WebDSL/773

    entity Test {
    	a : String
    	t : Test2
    	t3 : Test3
    	
    	validate (t == null || t.t == this.t3, "error")
    }
    entity Test2 {
    	a : String
    	t : Test3
    }
    
    entity Test3 {
    	a : String
    }
    
    
    define page root(){
    	"hi"
    }