application root

  page root(){
    "12345"
    a(error.error())
    output(from TmpEnt)
  }
  
  template a(i:Int){
    output(i)
  }
  
  native class tmp.StaleError as error{
    static error(): Int
  }
  
  entity TmpEnt{}
   
  test rendertemplatevariants{
  	var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root())); // first request simulates an error, shouldn't be cached
  	for(i:Int from 0 to 5){
      d.get(navigate(root()));
      assert(d.getPageSource().contains("12345"));
    }
  }
  