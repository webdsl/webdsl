//Attribute type Void is not allowed in attribute

application test

section datamodel

  entity User {
    authoredPapers :: Void
  }

  define page root(){}