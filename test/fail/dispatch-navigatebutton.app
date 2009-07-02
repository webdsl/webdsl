//Not a valid navigate link
application test

  entity Journal{
    title :: String
  }

  define page home(){
    for(jo:Journal){
      navigate("show" + jo.title, hom/jo) 
    }
  }
