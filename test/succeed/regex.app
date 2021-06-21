application test


  define page root() {
    if(/[0-9]/.find("ofsdfjsd=s7")){
      "1 "
    }
    if(/[0-9]/.match("of44ft")){
      "error"
    }
    if(/df/.find("ofsdfjsd767g---==ifjs7")){
      "2 "
    }
    if(/5/.find("jfg782dfF")){
      "error"
    }
    if(/1234[0-9]/.match("12349")){
      "3 "
    }
    
    for(s : String in /-/.split("1-10-100-1000")){
      output(s)
    }separated-by{".."}
    
    break
    
    output(/ \/ /.replaceAll("-", "1/10/100/1000"))
    
    break
    
    output(/-/.replaceFirst("/", "1-10-100-1000"))
    
    break
    
    output(/-/.replaceAll("/", "1-10-100-1000"))
 
    break
    
    output(/\./.replaceAll("/", "1.10.00.000"))
 
    
  }
  
  function replacenewline1(x : String) : String {
    return /\n/.replaceAll("",x);
  }
  function replacenewline2(x : String) : String {
    return /[\n]/.replaceAll("",x);
  }
  function replacenewline3(x : String) : String {
    return /\r|\n|\r\n/.replaceAll("",x);
  }
  
  
  function multiRegex(x : String) : Bool {
  	//previously caused amb when / was accepted as AtomLiteral
    var baseUri := /(.*getFile).*/.replaceAll("$1", x);
    var numFileRefs := x.split(baseUri).length;
    var unresolved := /\]\([^:]+\)/.find(x);
    return numFileRefs < 1 || !unresolved ;
  }

  test regexnewline {
    assert(replacenewline1("\n1\n2\n3\n4\n\n") == "1234");     
    assert(replacenewline2("\n\n\n\n\n1234\n") == "1234");     
    assert(replacenewline3("\r\n\r\n") == "");     
    assert(replacenewline3("1\r2\n3\r\n4") == "1234");     
    
  }
