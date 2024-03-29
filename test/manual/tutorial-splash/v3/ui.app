module ui

  define t(){
    <table>
      elements()
    </table>
  }
  define r(){
    <tr>
      elements()
    </tr>
  }
  define c(){
    <td>
      elements()
    </td>
  }

  define eventEdit(e:Event){
    label("Name:"){
        input(e.name){
          validate(e.name.length()>0,"name required")
        }
      }
      label("Description:"){
        input(e.description)
      }
      label("Slots:"){
        for(slot : Slot in e.slots) {
          input(slot.time)
          <br />
        }
        validate( And[s.time.length()>0 | s:Slot in e.slots],"time slot description required for each slot")
      }

      submit action{ e.slots.add(Slot{}); }[ignore-validation] {"add slot"}
  }

  define page admin(e:ALink){
    title{"administration"}

    form{
      eventEdit(e.event)

      submit action{ return participants(e.event); } { "save event" }
    }
  }

  define page event(e:PLink){
    title{"participants"}
    var up := UserPreference{}
    form{
      label("Name:"){
        input(up.user)
      }
      <br />
      label("Slots:"){
        t{
          for(slot : Slot in e.event.slots) {
            r{
              pickOption(up,slot)
            }
          }
        }
      }
      submit action{ e.event.userPrefs.add(up); return participants(e.event); } { "save preference" }
    }

    //showEvent(e.event)
  }

  define pickOption(up:UserPreference,slot:Slot){
    var p := Preference{}
    c{
      output(slot.time)
    }
    c{
      radio(p.option, [p_yes,p_no,p_maybe])
    }
    databind{
      up.prefs.add(Preference{slot := slot option := p.option});
    }
  }

  define showEvent(e:Event){
    output(e.name)
    <br />
    output(e.description)
    <br />
    t{
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

  define page participants(e:Event){
    showEvent(e)
  }
  
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


