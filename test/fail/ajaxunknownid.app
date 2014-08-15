//'fo0' not defined
//'fo1' not defined
//'fo2' not defined
//'fo3' not defined
//'fo4' not defined
//'fo5' not defined

application test

page root(){
  placeholder foo{}
  block[onclick := action{ 
      replace(fo0,bar());
      append(fo1,bar());
      visibility(fo2,show);
      restyle(fo3,"");
      clear(fo4); 
      replace(fo5);
    }]{ "test" } 
}

ajax template bar(){}