//must be of collection type

application test

entity Dish {
   name     :: String
   tags    -> Set<Tag>
}

entity Tag {
  name :: String
}


define page root() {
 //...
 form {
   var d: Dish
   "dish: " select(d from Dish)
 }
}