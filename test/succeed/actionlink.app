application test

  entity User{
    s :: String
    i :: Int
    b :: Bool
    t :: Text
    u -> User
  }

  var u_1 := User {}
  var u_2 := User {}

  define page red(){"redirected"}

  define page test(s1:String,s2:String,s3:String){
    output(s1+s2+s3)
    actionLink("refresh",ref())
    action ref(){
    
    }
  }

  define page root()
  {
  
    navigate(test("12","34","56")){"test page"}
    
    action ret(i:Int, s:String, b:Bool, u:User,t:Text) {
      var temp := User {
        s := s
        i := i
        b := b
        u := u
        t := t
      };
      temp.save();
      return red();
    }
    
    for(u:User){
      output(u.s)
      output(u.i)
      output(u.b)
      //output(u.t)
    }
    
       
    form {
      actionLink("imlicit return",action{u_2.s := "default";})
      
      
      actionLink("return",ret(42," first ",true,u_1,"dfgdfg"))

      for(i:Int from 0 to 5){
        actionLink("return"+i,ret(i," second ",true,u_1,"dfgdfg"))
      }
    }
    
    break
    for(i:Int from 200 to 205){
      form{
        input(u_2.b)
        input(u_2.s)
        actionLink("return"+i,ret(i,u_2.s,u_2.b,u_1,"dfgdfg"))
      }
    }
    
    break

    
    for(i:Int from 0 to 5){
      for(j:Int from 0 to 5){
        for(k:Int from 0 to 5){
          form{
            actionLink("return",ret(9," third ",true,u_1,"dfgdfg"))
          }
        }
      }
    }

  }
