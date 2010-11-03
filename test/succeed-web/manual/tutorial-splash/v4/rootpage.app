module rootpage

  define page root(){
    auth()
    <br />
    form{
      submitlink action{
        var e := Event{
          organizer := securityContext.principal
          slots := [ Slot{ } ]
        };
        e.save();
        return new(e);
      } { "Create new event" }
    }

    <br />
    for(e:Event){
      showEvent(e)
    } separated-by{ <br />  }

  }
