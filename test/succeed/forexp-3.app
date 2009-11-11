application test

  define page root() {

  }

  function findDblpAuthors(name : String) : Bool {
    log("Finding DBLP authors with name " + name);
    var likename : String := "%" + name + "%";
    var aliases : List<Alias> := [author.alias | author : DBLP_Author in (from DBLP_Author as a where a.name like ~likename or a.name = ~name)];
    return aliases.length > 0;
  }
  
  entity DBLP_Author{
    alias -> Alias
    name :: String
    function findDblpAuthors(name : String) : Bool {
      log("Finding DBLP authors with name " + name);
      var likename : String := "%" + name + "%";
      var aliases : List<Alias> := [author.alias | author : DBLP_Author in (from DBLP_Author as a where a.name like ~likename or a = ~this)];
      return aliases.length > 0;
    }
  }
  entity Alias{}