application test

  entity Person{
  fullname    :: String (name)
  email       :: Email
  username    :: String 
  bio         :: WikiText
  dateOfBirth :: Date
  parents     -> Set<Person>
  children    -> Set<Person> (inverse = Person.parents)
  photo       :: Image
  admin       :: Bool
  favoriteColor -> Color
  }
  derive CRUD Person
  entity Color{}
  page root(){
    
  }
  
  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(createPerson()));
    assert(d.getPageSource().contains("Photo"));
  }