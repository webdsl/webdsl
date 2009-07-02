//Not a valid navigate link
application test

  entity Journal{
    title :: String
  }

  define page home(){
    for(jo:Journal){
      navigate(hom/jo/dfg/g/df){ "show" output(jo.title) } 
    }
  }
