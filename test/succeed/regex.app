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
    
    output(/ / /.replaceAll("-", "1/10/100/1000"))
    
    break
    
    output(/-/.replaceFirst("/", "1-10-100-1000"))
    
    break
    
    output(/-/.replaceAll("/", "1-10-100-1000"))
 
    break
    
    output(/\./.replaceAll("/", "1.10.00.000"))
 
    
  }
