application test

section pages

define page home() {
  block[id:= hoi, 
          onclick := { 
                      replace hoi << template {
                         block[ onclick := { replace this << template { spacer spacer }; } ] { "hoi2"}
                      }; 
                    }
        ] { "hoi" }
}
