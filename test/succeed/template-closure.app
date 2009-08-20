//should display "1"

application test

section datamodel

 define one(tab : String) {
   two("2")
   define localBody() {
     output(tab)
   }
 }
 
 define two(tab : String) {
   localBody()
 }
 
 define localBody(){}

 define page root() {
   one("1")
 }
 
