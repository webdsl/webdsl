// Function with signature setTitle(Int) for entity Test overloads a builtin function
application test

  entity Test	{
    title :: String
    
    // property event
    function setTitle(s : String) {
    	title := "x";
    }
    
    // trigger constraint
    function setTitle(i : Int) {
    
    }
  }

  define page root(){
   
  }
  
