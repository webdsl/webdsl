application versionthree

  imports data
  imports lib
  imports ui
  imports invite
  imports rootpage

  //task 1

  extend entity Event{
    invitees -> List<User>
  }
  
  //task 2

  entity User{
    name :: String
    email :: Email
  }

  //task 3
  
    define page new(e:Event){
    form{
      eventEdit(e)
      submit save() { "create event" }
    }

    action save(){
      e.aLink := ALink{};
      e.pLink := PLink{};
      //different from v2
      e.invitees := [User{}];
      //
      return completed(e);
    }
  }
  
  //task 4

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