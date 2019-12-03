application testapp

    entity Test {
    	others -> List<Test>
    	function addstuff(){
    		others.add(Test{ others := [globalt]});
    		log(bla.name);
    	}
    	extend function addToOthers(test:Test){
    		log(globalt.toString());
    		//log(bla.toString());
    	}
    }
    
    session bla { name :: String }
    
    var globalt := Test{}

    define page root(){
    	output(globalt.others)
    	submit action{ globalt.addstuff(); return root(); } { "add" }
    }

    function someFunction() {
      globalt.addstuff();
      log("I was executed!");
    }

    invoke someFunction() every 10 seconds
