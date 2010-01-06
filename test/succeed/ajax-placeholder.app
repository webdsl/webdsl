application test

  define page root() {
    placeholder one{
      bla("dfsf")
    }  
  }
  
  define ajax bla(s:String){
    output(s)
    block[onclick := action{ replace(one,test(45)); }]{
      "click to swap"
    }
  }
  
  define ajax test(i:Int){
    output(i)
    block[onclick := action{ replace(one,bla("g34gf")); }]{
      "click to swap"
    }
  }