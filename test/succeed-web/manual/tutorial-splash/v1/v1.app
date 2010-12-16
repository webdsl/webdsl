application version1

imports data
imports rootpage

  //task1 

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
  }

  entity PrefOption {
    name :: String
  }