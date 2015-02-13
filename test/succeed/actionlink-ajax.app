application test

  entity User{
    s :: String
    i :: Int
    b :: Bool
    t :: Text
    u -> User
  }

  var u_1 := User {}

  define page red(){"redirected"}

  define page root()
  {
    action ret(i:Int, s1:String, b1:Bool, u:User,t:Text) {
      var temp := User {
        s := s1
        i := i
        b := b1
        u := u
        t := t
      };
      temp.save();
      return root();
    }
    action enableajax() {
      replace(p,bla());
    }
    placeholder p {}
    
    for(u:User){
      output(u.s)
      output(u.i)
      output(u.b)
      //output(u.t)
    }
       
    form { 
      actionLink("return",ret(42," first ",true,u_1,"dfgdfg"))

      for(i:Int from 0 to 5){
        actionLink("return"+i,ret(i," second ",true,u_1,"dfgdfg"))
      }
    }
    
    break
    var b : Bool
    var s : String := " third "
    for(i:Int from 200 to 205){
      form{
        input(b)
        input(s)
        actionLink("return"+i,ret(i,s,b,u_1,"dfgdfg"))
      }
    }
    
    break

    
    for(u:User){
      form{
        actionLink("return",ret(9," third ",true,u_1,"dfgdfg"))
      }
    }

  }

  define ajax bla(){
    "sdfsd"
  }