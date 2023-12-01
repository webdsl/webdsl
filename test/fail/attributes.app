//expression 4 has type Int
//has type \[Bool\]
//has type \[Float\]
//expression Test{} has type Test
//expression Test{} has type Test
//has type \[Test\]
// has type \[Int\]
//expression false has type Bool

application test

entity Test{}

page root {

  container[
    class = "scopediv border rndButton " + attribute( "class", "" ),
    onclick = "" + attribute( "onclick", "" ),
    style = attribute( "style" ),
    all attributes,
    attributes 4,
    attributes [ true ],
    all attributes except [0.0,0.1],
    all attributes except Test{}
  ]{}

  <div
    class = "scopediv border rndButton " + attribute( "class", "" )
    onclick = "" + attribute( "onclick", "" )
    style = attribute( "style" )
    all attributes
    attributes Test{}
    attributes [ Test{} ]
    all attributes except [ 4, 4, 6, 4, 56 ]
    all attributes except false
  ></div>

}
