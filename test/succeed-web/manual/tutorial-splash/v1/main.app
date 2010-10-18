application v1

  define page root(){ 
    navigate manageEvent() {"events"}	
    <br />
    navigate manageSlot() {"slots"}
    <br />	
    navigate managePreference() {"preference"}	
  }
  
  entity Event {
    name :: String
    slots -> Set<Slot> (inverse = Slot.event)
  }
  
  entity Slot {
    startTime :: DateTime
    endTime :: DateTime
    event -> Event
    preferences -> Set<Preference> (inverse = Preference.slot)
  }
  
  entity Preference {
    slot -> Slot
    option -> PrefOption
    comment :: WikiText
    user :: String
  }
  
  entity PrefOption {
    name :: String
  }
  
  var p_yes := PrefOption{ name := "yes" }
  var p_no := PrefOption{ name := "no" }
  var p_maybe := PrefOption{ name := "maybe" }
  
  init{
    var e := Event{
      name := "Important meeting"
    };
    var s := Slot{ 
      event := e
    };
    var p := Preference{ 
      slot := s 
      option := p_yes 
    };
    
    e.save();
  }
  
  derive crud Event
  derive crud Slot
  derive crud Preference
  //PrefOption entities do not have to be edited
  