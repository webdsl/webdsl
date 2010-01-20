// Function with signature Test(Int) for entity Test overloads a builtin function
application test

  entity Test	{
  
  	t :: String
  
  	// entity event
  	function Test() {
  		t := "x";
  	}
  	
  	// trigger constraint	
    function Test(i : Int) {
    
    }
  }

  define page root(){
   
  }
  
