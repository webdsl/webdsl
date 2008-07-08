// Expected: Simple type. Encountered: Set<Paper>

application test

section datamodel

  entity User {
    authoredPapers :: Set<Paper>
  }

  entity Paper {
  }