application test

  entity Test {
    prop :: Bool
  }
  
  var t1 := Test { }
  var t2 := Test { }
  var t3 := Test { }
  var t4 := Test { }
  
  define page root() {
    for(t:Test){
      output(t.prop)
    }
    
    form{
      for(t:Test){
        inputtest(t)
      }
      action("save",action{refresh();})
    }
    
    break
    
    test2
  }
  
  define inputtest(t:Test){
    input(t.prop)
  }
  
  entity AbstractAuthor {
    selected :: Bool
    another -> AbstractAuthor
  }

  define bla(){}
  
  init{
 
    var a1 := AbstractAuthor { };
    a1.save();
    a1.version := 4;
    
    var a2 := AbstractAuthor { another := a1 };
    var a3 := AbstractAuthor { another := a2 };
    var a4 := AbstractAuthor { another := a3 };
    var a5 := AbstractAuthor { another := a4 };
    var a6 := AbstractAuthor { another := a5 };
    
    a6.save();
  }

  define test2(){
    bla()
    define bla(){
      var authors : List<AbstractAuthor> := getUnidentifiedPublications()
      form{
        list[class = "publicationList"] {
          for(author : AbstractAuthor in authors) {
            listitem{ identifyPublication(author) }
          }
        }
        action("Submit", action{})    
      }
    }
  }
    
  define identifyPublication(author : AbstractAuthor) {
    input(author.selected)
  }
  
  function getUnidentifiedPublications() : List<AbstractAuthor> {
    var authors : List<AbstractAuthor> := from AbstractAuthor;
    return authors;    
  }
  