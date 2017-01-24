//#3 Only functions that have a return type can be cached. Remove the cached keyword, or changed the function to return a result.
//#3 Only functions without arguments can be cached. Remove the cached keyword, or changed the function to not have arguments.

application test

  entity User{
    name :: String
    cached function test1(i : Int) : Bool{
    	return true;
    }
    cached function test1() {
    	
    }
  }
  
  extend entity User{

    cached function test2(i : Int) : Bool{
    	return true;
    }
    cached function test2() {
    	
    }
  }

  define page root(){
    var u:User := User{};
    output(u.name)
   }

  cached function gt1(i : Int) : Bool {
    return true;
  }
  cached function gt2(){}