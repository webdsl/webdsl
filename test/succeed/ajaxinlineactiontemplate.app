application test

section pages

define page home() {
  block[id:= "hoi", 
          onclick := @ replace hoi << @ \ block[ onclick := @ replace this << @ { spacer } ] { "hoi2"} 
        ] { "hoi" }
}
