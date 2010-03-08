//Cannot derive for non-entity types.
application crudpages

  define page root() {
  
  	var x : List<String>
  	derive editPage from x
  
  }
  