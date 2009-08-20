application test

section datamodel

  entity User {
    authoredPapers  -> Paper (inverse=Paper.authors)
  }

  entity Paper {
    authors        -> Set<User>
  }

  define page root() {
  }
