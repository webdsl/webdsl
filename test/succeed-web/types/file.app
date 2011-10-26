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
      input(e1.f)[class="file-input"]
      submit action{}[class="file-input-button"] {"save"}
    }
    " "
    output(e1.f)
    output(e1.f.getContentType())
    navigate getfile() {"[get file]"}
    output(e1.f.getContentAsString())
    
    <br/>
    <br/>
    <br/>
    "image: "
    form{
      input(e1.i)[class="image-input"]
      submit action{}[class="image-input-button"] {"save"}
    }
    " "
    output(e1.i)
    output(e1.i.getContentType())
    output(e1.i.getContentAsString()) 
  }

  define page getfile(){
    init{
      e1.f.setContentType("application/blubber");
      e1.f.download();
    }
  }

  test upload{
    var teststring := "webdsl-test-file";
    var d := getFirefoxDriver();
    d.get(navigate(root()));
    var e := d.findElement(SelectBy.className("file-input"));
    e.sendKeys(createTempFile(teststring));
    d.findElement(SelectBy.className("file-input-button")).click();
    assert(d.getPageSource().contains(teststring));

    var teststring2 := "webdsl-test-image-file";
    var e := d.findElement(SelectBy.className("image-input"));
    e.sendKeys(createTempFile(teststring2));
    d.findElement(SelectBy.className("image-input-button")).click();
    assert(d.getPageSource().contains(teststring));
  }
