// #4 Inverse annotations cannot be declared on both sides.

application test

section datamodel

  entity User {
    authoredPapers  -> Set<Paper> (inverse=Paper.authors)
  }

  entity Paper {
    title          :: String (name)
    abstract       :: Text
    authors        -> Set<User> (inverse=User.authoredPapers)
    accepted       :: Bool
    final          :: Bool
  }
  
  entity Entry {
    testA -> Entry (inverse = Entry.testB)
	}
	
	extend entity Entry {
	  testB -> Entry (inverse = Entry.testA)
	}
	
	extend entity Entry {
	}