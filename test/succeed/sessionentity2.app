/*
 *  use of session var for registering view counts, where a view is count only once per session
 */
 
application test
 
  var p1 := Publication{ title := "p1" };
  var p2 := Publication{ title := "p2" };
  var p3 := Publication{ title := "p3" };
  
  define page root(){
    table{
      for(p : Publication){
        output(p)
      }
    }
  }
  
  define page publication(p:Publication){
    init{
      p.incrementViews();
    }
    "title: " output(p.title)
    " views: " output(p.views)
    " "
    navigate(root()){"home"}
  }
   
  session stats {
    publications -> Set<Publication>
  }

  entity Publication {
    views   :: Int
    title :: String (name)
    function incrementViews() {
      if(!(this in stats.publications)) {
        stats.publications.add(this);
        this.views := this.views + 1;
        this.save();
      }
    }
  }

  
  principal is Publication with credentials title
  
  access control rules
   
    rule template *(*){true}
    rule page *(*){true}