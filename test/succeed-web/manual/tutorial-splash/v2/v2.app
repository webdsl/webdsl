application versiontwo

  imports data
  imports lib
  imports ui

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

  define page new(e:Event){
    form{
      eventEdit(e)
      submit save() { "create event" }
    }

    action save(){
      validate(e.name.length()>0,"name required");
      for(slot:Slot in e.slots){
        validate(slot.time.length()>0,"you must specify a time description for each slot");
      }
      e.aLink := ALink{};
      e.pLink := PLink{};
      return completed(e);
    }
  }

  define page completed(e:Event){
    label("administration link"){
      navigate admin(e.aLink) { output(navigate(admin(e.aLink))) }
    }
    label("participation link"){
      navigate event(e.pLink) { output(navigate(event(e.pLink))) }
    }
  }