//A boost value should be type of 'Float', but is: String
application test

entity A {
    name :: String (searchable)
    
    function search(){
      var boost := DateTime("06/05/1994 13:12");
      search A matching name^"afsgf": "harry";
      search A matching name^boost: "harry";
    }
}

page root(){
  
}