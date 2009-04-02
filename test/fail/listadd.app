//No function 'add' for 'list' with this signature list.add(Entity{})

application test

  entity Entity{}

  function do() {
    var list : List<String> := List<String>();
    list.add(Entity{});
  }
