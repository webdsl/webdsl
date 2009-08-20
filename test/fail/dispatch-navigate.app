//Not a valid navigate link
application test

  entity Journal{
    title :: String
  }

  define page root(){
    for(jo:Journal){
      navigate(hom/jo/dfg/g/df){ "show" output(jo.title) } 
    }
  }
