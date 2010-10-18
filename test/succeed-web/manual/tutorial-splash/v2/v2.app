application versiontwo

  imports data
  imports lib
  imports ui

  define showAllEvents(){
    <br />
    <br />
    "All events: "
    <br />
    for(e:Event){
      showEvent(e)
      <br />
    }
  }

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

  define page new(e:Event){
    form{
      eventEdit(e)
      submit save() { "create event" }
    }

    action save(){
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