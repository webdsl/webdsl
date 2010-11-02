application v2

  imports data
  imports lib
  imports ui
  imports rootpage
  
  
  /*
    definitions to be implemented:
      define page admin(a:ALink){}
      define page completed(e:Event){}
      define showEvent(e:Event){}
      define page participants(e:Event){}
      define showAllEvents(){}
  */
  
  //task 1

  extend entity UserPreference{
    validate(user.length()>0,"name required")
  }
  
  //task 2
  
  define page admin(a:ALink){
    title{"administration"}

    form{
      eventEdit(a.event)

      submit action{ return participants(a.event); } { "save event" }
    }
  }

  //task 3

  define page completed(e:Event){
    label("administration link"){
      navigate admin(e.aLink) { output(navigate(admin(e.aLink))) }
    }
    label("participation link"){
      navigate event(e.pLink) { output(navigate(event(e.pLink))) }
    }
  }

  //task 4

  define showEvent(e:Event){
    output(e.name)
    <br />
    output(e.description)
    <br />
    t{ //abuse <table> for convenient layout
      r{
        c{}//empty column above user names
        for(s:Slot in e.slots){
          c{
              output(s.time)
          }
        }
      }
      for(up : UserPreference in e.userPrefs){
        r{
          c{output(up.user)}
          for(s:Slot in e.slots){
            c{output(up.getPrefForSlot(s).option.name)}
          }
        }
      }
    }
  }
  
  //task 5
  
  define page participants(e:Event){
    showEvent(e)
  }

  //task 6

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




