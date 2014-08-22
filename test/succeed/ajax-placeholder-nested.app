application test

  page root() {   
   action tmp(p:Placeholder){}
    bla("123", one, two, three)
    submit tmp(one) { " " }
    var i := 0
    inputajax(i)[class="input3", oninput=tmp(one)]
    form{
      placeholder one{
      placeholder two{
        placeholder three{
          
        }
      }
      }  
    }
  }
  
  define ajax bla(s:String, one: Placeholder, two: Placeholder, three: Placeholder){
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
  
  