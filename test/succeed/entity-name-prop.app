application entitynameprop

  entity NameAnno {
    x    :: String (name)
    y	 :: String
  }
  
  entity Nothing {
    x	 :: String
    y	 :: String
  }
  
  entity NoString {
    x	 :: Date
    y 	 :: Int
  }
  
  entity Implicit {
    x 	 :: Int
    name :: String
  }
  
  derive crud NameAnno
  
  derive crud Nothing
  
  derive crud NoString
  
  derive crud Implicit
 
  define standardmenu() {
  
    navigate(createNameAnno) { "Create NameAnno" }
    navigate(createNoString) { "Create NoString" }
    navigate(createImplicit) { "Create Implicit" }
  
    navigate(selectNameAnno) { "Select NameAnno" }
    // navigate(selectNoString) { "Select NoString" }
    // navigate(selectImplicit) { "Select Implicit" }
  
  }
 
  define page root(){
  
    standardmenu()
    
    var x : Nothing
    output(x.name)
    output(x.version)
    
    var y : Implicit
    output(y.name)
    
  }
  
  define page selectNameAnno() {
    
    standardmenu()
    
    var set : List<NameAnno> := from NameAnno;
    var e : NameAnno
    
    form {
      input(e)
    }
    
  }
  
  define page selectImplicit() {
    
    standardmenu()
    
    var set : List<Implicit> := from Implicit;
  var e : Implicit
    
    form {
      input(e)
    }
    
  }
  