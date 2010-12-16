application test

  entity Test2 : Test {
    
    prop2 :: String
    list2 -> List<Test>
    
    function test2() {
    
      this.prop := "aaa";
      prop2 := "aaa";
      prop := "aaa";
    
      this.list2 := null;
      list2 := null;
      
      this.list := null;
      list := null;
    }
    
  }
  
  entity Test {
    
    prop :: String
     list -> List<Test2>
     
    function test() {
    
      this.prop := "aaa";
      prop := "aaa";
       list := null;
      
      var local : Int;
      local := 3;
      
      // liststr := null;
      
     }
    
  }
  
  define page root(){
    var x : Int;
    
    init {
      x := 3;
    }
    
  }