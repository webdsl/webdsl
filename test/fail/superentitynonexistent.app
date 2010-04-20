// Super entity Nonexistent for User does not exist

application test

section datamodel

  entity User : Nonexistent {
    authoredPapers :: String
  }

  define page root() {
    "Hello world!"
  }
