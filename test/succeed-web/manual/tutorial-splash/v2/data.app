module data

  entity Event {
    name :: String
    description :: String
    slots -> List<Slot> (inverse = Slot.event)
    aLink -> ALink
    pLink -> PLink
    prefs -> List<EventPreference>

  }

  entity ALink {
    event -> Event (inverse=Event.aLink)
  }
  entity PLink {
    event -> Event (inverse=Event.pLink)
  }

  entity Slot {
    time :: String
    event -> Event
    preferences -> List<Preference> (inverse = Preference.slot)
  }

  entity Preference {
    slot -> Slot
    option -> PrefOption
    comment :: WikiText
    eventPref -> EventPreference (inverse=EventPreference.preferences)
  }

  entity EventPreference {
    preferences -> List<Preference>
    user :: String
    validate(user.length()>0,"name required")
    event -> Event
    function getPrefForSlot(s:Slot):Preference{
      for(pr:Preference in preferences){
        if(pr.slot == s){
          return pr;
        }
      }
      return null;
    }
  }

  entity PrefOption {
    name :: String
  }

  var p_yes := PrefOption{ name := "yes" }
  var p_no := PrefOption{ name := "no" }
  var p_maybe := PrefOption{ name := "maybe" }
  /*
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
  }*/

