application red

  page root(){
    init{
      goto one();
    }
    for(i:Int from 0 to 10000){
      <div class="dummy">"dummy content to fill buffer and trigger sending data to client"</div>
    }
  }
  
  page one(){
    "123"
  }
  
  test{
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("<body id=\"one\">"));
  }