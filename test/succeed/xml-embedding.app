application test

  define page root(){
    <h1 foo="value">
    <br />
    "title"
    <bla:br/>
    <foo:h2> </foo:h2>
    </h1>
    bla("www.te\"st.test")
  }
  
  define bla(val : String){
    <a href=val>
    output(val)
    </a>
  }
