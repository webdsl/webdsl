//Inverse not allowed between types

application test

section datamodel

  entity User {
    authoredPapers  -> Paper (inverse=Paper.authors)
  }

  entity Paper {
    authors        :: String
  }