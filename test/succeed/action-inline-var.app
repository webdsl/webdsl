// check for action at top-level in define was triggering on the var in the inline action

application test

  define page root(){
    action("create new admin",action{ var q : String; })
  }