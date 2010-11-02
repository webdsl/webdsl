module ui

  define no-span t(){
    <table>
      elements()
    </table>
  }
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
          input(slot.time){
            validate(slot.time.length() > 0, "time slot description required")
          }
          <br />
        } //separated-by{ <br /> }
      }

      submit action{ e.slots.add(Slot{}); } {"add slot"}
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
