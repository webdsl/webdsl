module data

  entity Event {
    name :: String
    description :: String
    slots -> List<Slot>
    userPrefs -> List<UserPreference>
    aLink -> ALink
    pLink -> PLink
  }

  entity ALink {
    event -> Event (inverse=Event.aLink)
  }
  entity PLink {
    event -> Event (inverse=Event.pLink)
  }

  entity Slot {
    time :: String
    event -> Event (inverse = Event.slots)
    prefs -> List<Preference>
  }

  entity Preference {
    slot -> Slot (inverse = Slot.prefs)
    option -> PrefOption
    comment :: WikiText
    userPref -> UserPreference
  }

  entity UserPreference {
    prefs -> List<Preference> (inverse = Preference.userPref)
    user :: String
    event -> Event (inverse = Event.userPrefs)
    function getPrefForSlot(s:Slot):Preference{
      for(pr:Preference in prefs){
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

  init{
    var e := Event{
      name := "Important meeting"
    };
    var s1 := Slot{
      event := e
      time := "16 Oct 8:30"
    };
    var s2 := Slot{
      event := e
      time := "16 Oct 13:30"
    };
    var p1 := Preference{
      slot := s1
      option := p_no
    };
    var p2 := Preference{
      slot := s2
      option := p_yes
    };
    var up := UserPreference{
      prefs := [p1,p2]
      event := e
      user := "some user"
    };
    e.save();
  }

