application test

page root {
  dark

  request var s := "123"

  submitlink action{
    s := "456";  // in code generator this is passed as a copy, should be ref
    replace( ph );
  }{ "refresh broken" }

  workaround( s, ph )

  placeholder ph {
    ~s
  }
}

template workaround( s: ref String, ph: Placeholder ){
  submitlink action{
    s := "456";  // because s is already a ref arg when passed to this template, this works
    replace( ph );
  }{ "refresh workaround" }
}



template dark{ <style>body { background-color: black; color: silver; }</style> }
