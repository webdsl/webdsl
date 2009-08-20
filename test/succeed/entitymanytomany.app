application test

section datamodel

  entity User {
    authoredPapers  -> Set<Paper> (inverse=Paper.authors)
  }

  entity Paper {
    authors        -> Set<User>
  }

  define page root() {
  }
