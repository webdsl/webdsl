application versionthree

  imports data
  imports lib

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

  define page root(){
    form{
      submitlink action{
        var e := Event{ slots := [ Slot{ } ] };
        e.save();
        return new(e);
      } { "Create new event" }
    }


    for(e:Event){
      showEvent(e)
    } separated-by{ <br />  }

  }

  define eventEdit(e:Event){
    label("Name:"){
        input(e.name)
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

  define page new(e:Event){
    form{
      eventEdit(e)
      submit save() { "create event" }
    }

    action save(){
      validate(e.name.length()>0,"name required");
      for(slot:Slot in e.slots){
        validate(slot.time.length()>0,"you must specify a time description for each slot");
      }
      e.aLink := ALink{};
      e.pLink := PLink{};
      return completed(e);
    }
  }

  define page completed(e:Event){
    label("administration link"){
      navigate admin(e.aLink) { output(navigate(admin(e.aLink))) }
    }
    label("participation link"){
      navigate event(e.pLink) { output(navigate(event(e.pLink))) }
    }
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
    var ep := EventPreference{}
    form{
      label("Name:"){
        input(ep.user)
      }
      <br />
      label("Slots:"){
        <table>
        for(slot : Slot in e.event.slots) {
          r{
            pickOption(ep,slot)
          }
        }
        </table>
      }
      submit action{ e.event.prefs.add(ep); return participants(e.event); } { "save preference" }
    }

    //showEvent(e.event)
  }

  define pickOption(ep:EventPreference,slot:Slot){
    var p := Preference{}
    c{
      output(slot.time)
    }
    c{
      radiobutton(p.option, [p_yes,p_no,p_maybe])
    }
    databind{
      ep.preferences.add(Preference{slot := slot option := p.option});
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
      for(ep : EventPreference in e.prefs){
        r{
          c{output(ep.user)}
          for(s:Slot in e.slots){
            c{output(ep.getPrefForSlot(s).option.name)}
          }
        }
      }
    </table>
  }

  define page participants(e:Event){
    showEvent(e)
  }


