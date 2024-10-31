application test

section datamodel

  entity User {
    myPaper  -> Paper (inverse=authors)
    ownedPaper -> Paper (inverse=user)
  }

  entity Paper {
    authors        -> Set<User>
    user  -> User
    function setSameMyPaper(){
      for(a in authors){
        a.myPaper := this;
      }
      user.ownedPaper := this;
    }
  }

  define page root() {
  }


  var u1 := User{}
  var p1 := Paper{ authors := {u1} user := u1}
  
  //Tests issue where inverse side was removed/unset when other side was assigned the same entity as existing relation
  // https://yellowgrass.org/issue/WebDSL/969
  test{
    //force reload of entities with uninitialized ref properties which is needed to trigger the issue
    commitAndStartNewTransaction(); 
    
    assert(p1.authors.length == 1);
    assert(p1.user != null);
    p1.setSameMyPaper();
    assert(p1.authors.length == 1);
    assert(p1.user != null);
  }