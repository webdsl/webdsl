//action refers to unknown

application test

section pages

define page root() {
  placeholder foo{}
  block[onclick := action { clear(fo); }] { "hoi1"} 
}
