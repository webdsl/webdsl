// Type mismatch between inverse attribute type String and entity type User

application test

section datamodel

  entity User {
    authoredPapers  -> Paper (inverse=Paper.authors)
  }

  entity Paper {
    authors        :: String
  }