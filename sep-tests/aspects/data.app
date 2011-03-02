module data

imports
  main

entity Entry {
  
  title :: String (searchable)
  content :: String
  
  function write() {
    title := "xyz";
    content := "zzz";
    
    accesses := accesses + 1;
    
    if (title.length() < 2) {
      
    }
  }
  
}

entity User {
  
  name :: String
  
}

function abbreviate(s : String, length : Int) : String {
  if(s.length() <= length) {
    return s;
  } else {
    return "" + " ...";
  }
}
