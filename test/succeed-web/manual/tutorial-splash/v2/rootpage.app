module rootpage

    define page root(){
    form{
      submitlink action{
        var e := Event{ slots := [ Slot{ } ] };
        e.save();
        return new(e);
      } { "Create new event" }
    }
    showAllEvents()
  }