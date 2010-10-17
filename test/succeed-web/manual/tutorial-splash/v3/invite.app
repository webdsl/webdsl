module invite

  extend entity Event{
    invitees -> List<User>
  }

  define page new(e:Event){
    form{
      eventEdit(e)
      submit save() { "create event" }
    }

    action save(){
      for(slot:Slot in e.slots){
        validate(slot.time.length()>0,"you must specify a time description for each slot");
      }
      e.aLink := ALink{};
      e.pLink := PLink{};
      //different from v2
      e.invitees := [User{}];
      //
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
    //different from v2
    invitees(e)
    //
  }

  /**
   *  new definitions in v3
   */

  define invitees(e:Event){
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
