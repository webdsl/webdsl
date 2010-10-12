application versionthree

  imports data
  imports lib
  imports ac

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

  define auth(){
    if(loggedIn()){
      signout()
    }
    else{
      signin()
    }
  }

  define signout(){
    "Logged in as: " output(securityContext.principal.name)
    " "
    form{
      submitlink action{logout();} {"Logout"}
    }
  }

  define signin(){
    var name := ""
    var pass : Secret := ""
    form{
      label("name: "){ input(name) }
      label("password: "){input(pass)}
      <br />
      submit action{
        validate(authenticate(name,pass), "The login credentials are not valid.");
        message("You are now logged in.");
      } {"login"}

    }
  }

  define page root(){
    //authentication()<br />
    auth()
    <br />
    form{
      submitlink action{
        var e := Event{
          organizer := securityContext.principal
          slots := [ Slot{ } ]
        };
        e.save();
        return new(e);
      } { "Create new event" }
    }

    <br />
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
      e.invitees := [User{}];
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
    <br />
      "Invitees:"
    <br />
    form{
      for(u: User in e.invitees) {
        label("Name: "){ input(u.name) }
        label("Email: "){ input(u.email) }
        <br />
      }
      submit action{ e.invitees.add(User{}); } {"add invitee"}
      submit action{
        for(u:User in e.invitees){
          //fake email
          var email := renderemail(sendInvite(e,u));
          log("to: "+email.to);
          log("from: "+email.from);
          log("subject: "+email.subject);
          log("body: "+email.body);

          //send email
          //email sendInvite(e,u);
        }
      } {"send invites"}
    }
  }

  define email sendInvite(e:Event, u:User){
    to(u.email)
    from("pick@slot.com")
    subject("event invitation")

    "You are invited to event" output(e.name) "!"
    " Pick a time slot that suits you here: "
    navigate event(e.pLink) { output(navigate(event(e.pLink))) }
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

    navigate root(){"root"}
  }


