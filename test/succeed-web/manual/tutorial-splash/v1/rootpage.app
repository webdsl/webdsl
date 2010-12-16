module rootpage

  define page root(){
    navigate event((from Event)[0]) {"view event"}
    " "
    navigate manageEvent() {"manage events"}
  }

  derive crud Event
  derive crud Slot
  derive crud UserPreference
  derive crud Preference
