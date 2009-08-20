//Not a valid navigate link
application test

  entity Journal{
    title :: String
  }

  define page root(){
    for(jo:Journal){
      navigate("show" + jo.title, hom/jo) 
    }
  }
