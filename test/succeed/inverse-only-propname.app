application test

  entity Publication {
    name      : String
    cites     : {Publication}
    citedBy   : {Publication} (inverse = cites)
    authors   : [Author] (inverse = pub)
    authorset : {Author}
    oneauthor : Author
  }
  
  entity Author{
    name   : String
    pub    : Publication
    pubset : Publication (inverse = authorset)
    onepub : Publication (inverse = oneauthor)
  }
    
  var p1 := Publication{ name := "p1" }
  var p2 := Publication{ name := "p2" }
  var p3 := Publication{ name := "p3" }

  var a1 := Author { name := "a1" }
  var a2 := Author { name := "a2" }
  
  page root(){}
  
  test{
    p1.cites.add(p2);
    assert(p1 in p2.citedBy);
    
    p1.citedBy.add(p1);
    assert(p1 in p1.cites);

    p1.cites.remove(p1);
    assert(!(p1 in p1.citedBy));

    p2.citedBy.remove(p1);
    assert(!(p1 in p1.cites));
    

    p1.authors.add(a1);
    assert(a1.pub == p1);
    
    a2.pub := p1;
    assert(a2 in p1.authors);

    p1.authors.remove(a1);
    assert(a1.pub == null);

    a2.pub := null;
    assert(!(a2 in p1.authors));


    p1.authorset.add(a1);
    assert(a1.pubset == p1);
    
    a2.pubset := p1;
    assert(a2 in p1.authorset);

    p1.authorset.remove(a1);
    assert(a1.pubset == null);

    a2.pubset := null;
    assert(!(a2 in p1.authorset));
         
  
    p1.oneauthor := a1;
    assert(a1.onepub == p1);
    
    a2.onepub := p1;
    assert(a2 == p1.oneauthor);
    assert(a1.pub == null);
    
    a2.onepub := null;
    assert(p1.oneauthor == null);
           
  }
 
