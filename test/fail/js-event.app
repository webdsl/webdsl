//requires an action call, inline action or String expression

application test

  define page root() {
    var i :=6
    form{
      input(i)[onchange := i+7]
    }
  }