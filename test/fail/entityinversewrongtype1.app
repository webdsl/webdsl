//Inverse not allowed between types

application test

section datamodel

  entity User {
    authoredPapers  -> Set<String> (inverse=Paper.authors)
  }

  entity Paper {
    authors        -> Set<User>
  }