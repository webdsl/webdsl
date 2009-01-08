// Type mismatch between attribute type
application test

section datamodel

  entity User {
    authoredPapers  -> Set<Nonexisting> (inverse=Paper.authors)
  }

  entity Paper {
    authors        -> Set<User>
  }
