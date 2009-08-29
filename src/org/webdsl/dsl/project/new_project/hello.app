application APPLICATION_NAME

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
}

derive crud Person
