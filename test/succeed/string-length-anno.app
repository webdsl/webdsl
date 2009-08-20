application test


  entity User {
    s1 :: String (length = 2)
    s2 :: String (length = 5)
    s3 :: String (length = 1000)
    s4 :: String (length = 1000000)
    s5 :: String
    s6 :: Text
    s7 :: Secret
    s8 :: URL
    s9 :: WikiText
    s10 :: Patch
    s11:: Int
  }

  var u_1 := User {
    s1 := "12"
    s2 := "12345"
    s3 := "7593475937259792075932759827895432985783295729357839euifhdxvm,nxdjkjdhqwpofkjdsnmxmdb"
    s4 := "longer"
    s5 := "default length"
  }

  define page root() {
    output(u_1.s1)    
    output(u_1.s2)    
    output(u_1.s3)    
    output(u_1.s4)
    output(u_1.s5)
    
    form{
      input(u_1.s1)
      input(u_1.s2)
      input(u_1.s3)
      input(u_1.s4)
      input(u_1.s5)
      action("save",action{})
    }    

  }
