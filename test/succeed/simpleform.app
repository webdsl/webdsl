application test

section datamodel

  entity User{
    name :: String
    rank :: Int
    bool :: Bool
    text :: Text
    wiki :: WikiText
  }
    var u : User := User{
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
      input(u.name)
      input(u.rank)
      input(u.bool)
      input(u.text)
      input(u.wiki)
      
      action("save",save())
    }
    action save()
    {
      u.save();
    }

  }


