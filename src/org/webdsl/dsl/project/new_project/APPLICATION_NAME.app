application @APPLICATION_NAME@

description {
  A simple app that uses CRUD page generation for managing a Person entity
}

imports templates
section pages

define page root() {
  main()
  define body() {
    "Hello world!"
  }
}

entity Person {
  fullname    :: String (name)
  email       :: Email
  username    :: String (id, validate(isUniquePerson(this), "Username is taken")
                           , validate(username.length() > 0, "Username may not be empty"))
  bio         :: WikiText
  dateOfBirth :: Date
  parents     -> Set<Person>
  children    -> Set<Person> (inverse = Person.parents)
  photo       :: Image  
  admin       :: Bool
  favoriteColor -> Color
}

derive crud Person

entity Color {
  name :: String (id, validate(isUniqueColor(this), "Color exists already")
                    , validate(name.length() > 0, "Color name may not be empty"))
}

derive crud Color

init {
  var color : Color;
  color := Color { name := "blue" };
  color.save();
  color := Color { name := "yellow" };
  color.save();
  color := Color { name := "red" };
  color.save();
  color := Color { name := "green" };
  color.save();
}

test colorsInitialized {
  assert((from Color).length == 4);
}