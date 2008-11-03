application test

section pages

define page home() {
  table {
    <| ="linkse header"= | =[class:= rood] "rechse header, rood"= >
    <
      | 
        group("group") {
          <|"1" | "2">
          <|"3" | "4">
         }  
      |[class:= rood] 
       "rechtsonder, met streep"
       --
    >
  }

  = "below, a list" =
  list {
   * "1"
   * { "2" }
   * "3"
  }
  
  = "below, a block" =
  #{ "i am inside a block " }

  
  ="below, a link"=
  ~ home() : "i, refresh"
  
  ="another group"=
  group {
    < label("1"){"2"} >
    < label("3"){"4"} >
  }
}

style global 

.rood {
  font-color := Color.red;
}
