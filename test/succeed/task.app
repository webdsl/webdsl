application testapp

    entity Test {
    	others -> List<Test>
    	function addstuff(){
    		others.add(Test{ others := [t]});
    		log(bla.name);
    	}
    	extend function addToOthers(test:Test){
    		log(t.toString());
    		//log(bla.toString());
    	}
    }
    
    session bla { name :: String }
    
    var t := Test{}

    define page root(){
    	output(t.others)
    	submit action{ t.addstuff(); return root(); } { "add" }
    }

    function someFunction() {
      t.addstuff();
      log("I was executed!");
    }

    invoke someFunction() every 10 seconds
