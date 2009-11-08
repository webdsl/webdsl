application test

  entity Table {
    legs :: Int
  }
  extend entity Table {
    function addLeg(){
      legs := legs + 1;
    }
  }
  
  extend entity Table{
    function addTwoLegs(){
      this.addLeg();
      addLeg();
    }
  }
  
  define page root(){}
  
  function addTwoLegs(){
  }
    
  test addLegs {
  
    var t := Table{};
    assert(t.legs == 0);
    t.addTwoLegs();
    assert(t.legs == 2);
  } 