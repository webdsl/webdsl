application test

section pages

define page root() {
  block[id:= hoi, 
          onclick := action { 
                      replace (hoi, template {
                         block[ onclick := action { replace (this, template { spacer spacer }); } ] { "hoi2"}
                      }); 
                    }
        ] { "hoi" }
}
