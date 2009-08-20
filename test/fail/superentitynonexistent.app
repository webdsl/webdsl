// supertype Nonexistent is not a defined entity

application test

section datamodel

  entity User : Nonexistent {
    authoredPapers :: String
  }

  define page root() {
    "Hello world!"
  }
