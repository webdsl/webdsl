application versionthree

  imports data
  imports lib
  imports ui
  imports invite

  define page root(){
    form{
      submitlink action{
        var e := Event{ slots := [ Slot{ } ] };
        e.save();
        return new(e);
      } { "Create new event" }
    }

    for(e:Event){
      showEvent(e)
    } separated-by{ <br />  }
  }

  entity User{
    name :: String
    email :: Email
  }
