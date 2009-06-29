application test

  entity Bib{
    title :: String
  }

  var one := Bib { title := "Bib one" };

  define page home(){
    test(one)
    navigate(testpage(one as Entity)){"testpage"}
  }
  
  define test(o : Entity){
    if(o isa Bib){
      output((o as Bib).title)
    }
  }
  
  define page testpage(o:Entity){
    if(o isa Bib){
      output((o as Bib).title)
    }
  }
  
  define page download(resource : String, object : Entity, type : String) {
    case(resource, type) {
      "bibliography", "bibtex" {
         if(object is a Bib) {
            downloadBibliographyBibtex(object as Bib)
         }
      }
      default {
        mimetype("text/plain")
        "no such resource available (to you) for download"
      }
    }
  }
  
  define downloadBibliographyBibtex(b:Bib){ "test" }