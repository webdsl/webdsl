//should create only one table for the relation

application test

  entity Publication {
    name :: String
    cites  -> Set<Publication>
    citedBy -> Set<Publication> (inverse=Publication.cites)
  }
  
  define page publication(p:Publication){
  
  }
  
  var p1 := Publication{ name := "p1" };
  var p2 := Publication{ name := "p2" };
  var p3 := Publication{ name := "p3" };
 
  define page root(){
    for(p:Publication){
      "name: " output(p.name)
      break
      "cites: " output(p.cites)
      break
      "citedBy: " output(p.citedBy)
      break
    } 
    for(p:Publication){
      form{
        "name: " output(p.name)
        break
        "cites: " input(p.cites)
        break
        action("save",save(p))
      }
      form{
        "citedBy: " 
        //input(p.citedBy)
        input(p.citedBy, {p1,p2})
        break
        action("save",save(p))
      }
    } 
    action save(p:Publication){
      p.save();
    }
  }
 
