//this example was causing a compilation error, the contents of the local body template 
// in editpage was being generated twice in the resulting Java class

application derive

  entity News{    
    name :: String
  }
  define page root(){}
  
  define page editNews(item: News) {
    "edit page"
    derive editPage from item
  }
  
  principal is News with credentials name