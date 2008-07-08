// Type mismatch between attribute type Set<String> and inverse entity type Paper

application test

section datamodel

  entity User {
    authoredPapers  -> Set<String> (inverse=Paper.authors)
  }

  entity Paper {
    authors        -> Set<User>
  }