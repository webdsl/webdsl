application text

  entity WikiTextHolder{
    text :: WikiText
  }

  define page root(){
  }
  
  test textFunctions {
  
    var s1 : WikiText := "12345";
    s1 := "";
    
    var e1 := WikiTextHolder{};
    e1.text := "dfsgdsgsf@dfgdsffd.dfg";
    e1.save();

  }
   
  test defaultValue{
    var s : WikiText;
    assert(s == "");
  }
  
  test stringfunctions{ 
  
    var s1 : WikiText := "12345";
  
    //contains
    assert(s1.contains("3"));
    assert(!s1.contains("8"));
        
    //length
    assert(s1.length() == 5);
    assert(s1.length() != 3);

    var s2 : WikiText := "12";
    var s3 : WikiText := "rj3k2hrkjfesj";

    //parseInt
    assert(s2.parseInt() == 12);
    assert(s3.parseInt() == null);
    
    var s4 : WikiText := "550e8400-e29b-41d4-a716-446655440000";
    
    //parseUUID
    assert(s4.parseUUID().toString() == "550e8400-e29b-41d4-a716-446655440000");
    assert(s3.parseUUID()==null);

    //toUpperCase
    assert(("sdfewrgdbtg123" as WikiText).toUpperCase() ==  "SDFEWRGDBTG123");

    //toLowerCase    
    assert(("SDFEWRGDBTG123" as WikiText).toLowerCase() as WikiText == "sdfewrgdbtg123" as WikiText);

    //split
    assert(("34gDE" as WikiText).split() == ["3","4","g","D","E"]);
    assert(("34gDE" as WikiText).split().concat() == "34gDE");
    assert(("34gDE" as WikiText).split().concat(", ") == "3, 4, g, D, E");
    
    assert(("34gDE" as WikiText).split("4").concat("4") == "34gDE");
    assert(("ery54h-tyjfu-kfyj-u" as WikiText).split("-").length == 4);
    assert(("tfhfg6tyhj" as WikiText).split().concat("-") == "t-f-h-f-g-6-t-y-h-j");
    
  }
  test renderingFunctions{
     //check rendering or URLs
    var t : WikiText := "[some link](http://example.org)";
    var rendered := rendertemplate( output(t) );
    var rawRendered := rendertemplate( rawoutput(t) );
    assert( rendered.contains("<a href") );
    assert( rawRendered.contains("<a href") );
    assert( rendered.contains("rel=\"nofollow\"") );
    assert( !rawRendered.contains("rel=\"nofollow\"") );
        
    t := "http://example.org";
    rendered := rendertemplate( output(t) );
    rawRendered := rendertemplate( rawoutput(t) );
    assert( rendered.contains("<a href") );
    assert( rawRendered.contains("<a href") );
    assert( rendered.contains("rel=\"nofollow\"") );
    assert( !rawRendered.contains("rel=\"nofollow\"") );
    
    t := "<a href=\"http://example.org\">text</a>";
    rendered := rendertemplate( output(t) );
    rawRendered := rendertemplate( rawoutput(t) );
    assert( rendered.contains("<a href") );
    assert( rawRendered.contains("<a href") );
    assert( rendered.contains("rel=\"nofollow\"") );
    assert( !rawRendered.contains("rel=\"nofollow\"") );
    
    t := "<div> <li> unclosed";
    rendered := rendertemplate( output(t) );
    rawRendered := rendertemplate( rawoutput(t) );
    log(rendered);
    assert( rendered.contains("</li>") );
    assert( rawRendered.contains("</li>") );
    assert( rendered.contains("</div>") );
    assert( rawRendered.contains("</div>") );
  } 
  
  test callStringArg{
    test("4343trg" as WikiText);
  }
  
  function test(e:WikiText){}
