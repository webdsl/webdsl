application exampleapp

  entity Ent {
    f :: File
    validate(f==null || f.fileName().length() > 5, "filename must be longer than 5 characters")
    i :: Image
    validate(i==null || i.fileName().length() > 5, "filename must be longer than 5 characters")
  } 

  var e1 := Ent{ }

  define page root(){
    "file: "
    form{
      input(e1.f)
      submit action{} {"save"}
    }
    " "
    output(e1.f)
    output(e1.f.getContentType())
    navigate getfile() {"[get file]"}
    //output(e1.f.getContentAsString())
    
    <br/>
    <br/>
    <br/>
    "image: "
    form{
      input(e1.i)
      submit action{} {"save"}
    }
    " "
    output(e1.i)
    output(e1.i.getContentType())
    //output(e1.i.getContentAsString()) 
  }

  define page getfile(){
    init{
      e1.f.setContentType("application/blubber");
      e1.f.download();
    }
  }
  