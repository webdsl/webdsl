module data

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

