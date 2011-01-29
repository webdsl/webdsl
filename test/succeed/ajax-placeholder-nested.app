application test

  define page root() {
    bla("123")
    placeholder one{
      placeholder two{
        placeholder three{
          
        }
      }
    }  
  }
  
  define ajax bla(s:String){
    output(s)
    block[onclick := action{ 
      replace(one,test(45));
      replace(two,test(45));
      replace(three,test(45));
     }]{
      "click to swap"
    }
  }

  define ajax test(i:Int){output(i)}