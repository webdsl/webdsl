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
      outputString(u.name)
      outputBool(u.bool)
      outputInt(u.rank)
      outputText(u.text)
      outputWikiText(u.wiki)
    }
    "test page"

    form{
      inputString(u.name)
      inputInt(u.rank)
      inputBool(u.bool)
      inputText(u.text)
      inputWikiText(u.wiki)
      
      action("save",save())
    }
    action save()
    {
      u.save();
    }

  }


