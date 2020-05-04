// Property name is not allowed to overlap with entity name 'A'
// Property name is not allowed to overlap with entity name 'B'
// Property name is not allowed to overlap with entity name 'C'
// Property name is not allowed to overlap with entity name 'D'

application test

page root {}

entity A {
  A : {A}
  B : [A]
  C : B
  D : String
}
entity B {}
entity C {}
entity D {}
