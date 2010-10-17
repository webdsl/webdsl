module ui

  define no-span r(){
    <tr>
      elements()
    </tr>
  }
  define no-span c(){
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
        } //separated-by{ <br /> }
      }

      submit action{ e.slots.add(Slot{}); } {"add slot"}
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
        <table>
        for(slot : Slot in e.event.slots) {
          r{
            pickOption(up,slot)
          }
        }
        </table>
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
      radiobutton(p.option, [p_yes,p_no,p_maybe])
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
    <table>
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
    </table>
  }

  define page participants(e:Event){
    showEvent(e)
  }

