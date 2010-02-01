application test

section pages

define page root() {

  h { "en hier begint het weer opnieuw!" }
  t {
    r{ h{"linkse header"} cell[class:= rood] {"rechse header, rood"}}
    r{ 
      c{ 
        g("group") {
          gi{cell{"1"}  c{ "2" }}
          r { "3"  "4" }
        }
      }  
      c[class:= rood] { 
         "rechtsonder, met streep"
        sp
      }
    }
  }

  h{ "below, a list" }
  list {
   li{ "1"}
   li{ "2" }

  }
  
  h { "below, a block" }
  b{ "i am inside a block " }

  
  h{"below, a link"}
  link(root()) { "i, refresh" }
  form {
    button("i, refresh", action{ return root(); })
  }
  
  h{"another group"}
  group {
    gi{ lbl("1"){"2"} }
    r{ label("3"){"4"} }
  }  
}



style somestyle 

.rood {
  font-color := Color.red;
}
