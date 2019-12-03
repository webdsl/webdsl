application test

section datamodel

  entity User{
    name :: String
    rank :: Int
    bool :: Bool
    text :: Text
    wiki :: WikiText
  }
    var u1 : User := User{
      name := "bob"  
      bool := true
      rank := 3
      text := "text"
      wiki := "wiki"
    };
  
  define page root(){
    for(u:User)
    {
      output(u.name)
      output(u.bool)
      output(u.rank)
      output(u.text)
      output(u.wiki)
    }
    "test page"

    form{
      input(u1.name)
      input(u1.rank)
      input(u1.bool)
      input(u1.text)
      input(u1.wiki)
      
      action("save",save())
    }
    action save()
    {
      u1.save();
    }

  }


