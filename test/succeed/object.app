application test

  entity Bib{
    title :: String
  }

  var one := Bib { title := "Bib one" };

  
  define page home(){
    test(one)
  }
  
  define test(o:Object){
    if(o isa Bib){
      output((o as Bib).title)
    }
  }
  