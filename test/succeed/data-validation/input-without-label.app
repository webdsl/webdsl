/**
 *  Test input without label
 *
 */

application input

  entity User {
    name :: String (validate(name.length() > 2,"Name should be longer than 2 characters."))
    age :: Int (validate(age >= 0,"Age cannot be a negative number."))
    bool :: Bool
    float :: Float
    text :: Text
    wiki :: WikiText
    secret :: Secret
  }
  
  define page home() {
    for(us:User){
      output(us.name)" "
      output(us.age)" "
      output(us.bool)" "
      output(us.float)" "
      output(us.text)" "
      output(us.wiki)" "
      output(us.secret)" "
    }
    
    var u := User { name := "bob" }
    form {
      input(u.name)" "
      ageinput(u)
      input(u.bool)" "
      input(u.float)" "
      input(u.text)" "
      input(u.wiki)" "
      input(u.secret)" "
      
      action("save",save())
    }
    action save(){
      u.save();
    }
  }

  define ageinput(user:User) {
    input(user.age)" "
  }
  
  