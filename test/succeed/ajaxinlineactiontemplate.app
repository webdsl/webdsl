application test

section pages

define page home() {
  block[id:= hoi, 
          onclick := action { 
                      replace (hoi, template {
                         block[ onclick := action { replace (this, template { spacer spacer }); } ] { "hoi2"}
                      }); 
                    }
        ] { "hoi" }
}
