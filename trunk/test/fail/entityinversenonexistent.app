// Type mismatch between attribute type Set<Nonexisting> and inverse entity type Paper

application test

section datamodel

  entity User {
    authoredPapers  -> Set<Nonexisting> (inverse=Paper.authors)
  }

  entity Paper {
    authors        -> Set<User>
  }