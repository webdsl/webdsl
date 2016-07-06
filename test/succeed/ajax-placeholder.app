application test

  define page root() {
    placeholder one{
      bla("dfsf", one)
    }
    placeholder <span> two{
      bla("dfsf", two)
    }
    
    placeholder three bla("dfsf", three)
    placeholder <span> four bla("dfsf", four)    
    
  }
  
  define ajax bla(s:String, ph: Placeholder){
    output(s)
    block[onclick := action{ replace(ph,test(45, ph)); }]{
      "click to swap"
    }
  }
  
  define ajax test(i:Int, one: Placeholder){
    output(i)
    block[onclick := action{ replace(one,bla("g34gf", one)); }]{
      "click to swap"
    }
  }