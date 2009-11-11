application test

  define page root() {

  }
  
  entity Publication{}
  entity DBLP_Publication{
    publication -> Publication
    function publication():Publication{
      return publication;
    }
  }
  entity DBLP_Editor {
    name ::String
    publication->DBLP_Publication
  }
  entity DBLP_Author {
    name ::String
    publication->DBLP_Publication
  }
  
  entity Bla {
    lastUpdated :: DateTime
  }
  
  var importDBLP := Bla {}

  entity Alias{
    name ::String
    updatedFromDBLP :: DateTime 
    importedEditor ::Bool 
    importedAuthor::Bool
    
    author -> DBLP_Author
  
    function importPublicationsFromDBLP(lim : Int) {
      if(!importedAuthor || updatedFromDBLP == null || updatedFromDBLP.before(importDBLP.lastUpdated)) {
        log("Importing DBLP records for '" + this.name + "' as author");
        var name : String := this.name;
        
        var author := Publication{};
        
        var pubs : List<Publication> 
              := [pub.publication() 
                 | pub : DBLP_Publication 
                      in (select pub 
                            from DBLP_Publication as pub, DBLP_Author as a
                           where (a.name = ~name) and (a.publication = pub) and (pub.publication = null)
                           limit 5)
                   where pub.publication() != null];
        this.importedAuthor := (pubs.length == 0);
        this.updatedFromDBLP := now();
        
      }
      if(!importedEditor || updatedFromDBLP == null || updatedFromDBLP.before(importDBLP.lastUpdated)) {
        log("Importing DBLP records for '" + this.name + "' as editor");
        var name : String := this.name;
        var pubs : List<Publication> 
             :=  [pub.publication() 
                 | pub : DBLP_Publication 
                      in (select pub 
                            from DBLP_Publication as pub, DBLP_Editor as e
                           where (e.name = ~name) and (e.publication = pub) and (pub.publication = null)
                           limit 5)
                   where pub.publication() != null]; 
        this.importedEditor := (pubs.length == 0);
        this.updatedFromDBLP := now();
      }
    }
  }