//does not exist, required by
application crudpages

  entity SuperUser{
    profs -> Set<Profession>
  }

  entity User : SuperUser {
    username :: String
    prof -> Profession
    profs2 -> List<Profession2>
  }
  
  entity Profession {
    name :: String
  }
  entity Profession2 {
    name :: String
  }
 
  define page root(){

  }
  
  derive crud User