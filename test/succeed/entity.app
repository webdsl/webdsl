application test

  entity Bib{
    title :: String
  }

  entity Test{
    bla :: String
  }

  var one := Bib { title := "Bib one" };
  var two := Test { bla := "Test two" };

  define page root(){
    test(one)
    " "
    navigate(testpage(one as Entity)){"testpage"}
    " "
    navigate(testpage2(one as Entity, two as Entity)){"testpage2"}
  }
  
  define test(o : Entity){
    if(o isa Bib){
      output((o as Bib).title)
    }
    if(o isa Test){
      output((o as Test).bla)
    }
  }
  
  define page testpage(o:Entity){
    if(o isa Bib){
      output((o as Bib).title)
    }
  }
  
  define page testpage2(o:Entity, o2:Entity){
    test(o)
    test(o2)
  }
  
