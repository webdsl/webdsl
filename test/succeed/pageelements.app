application test

section datamodel

  entity User{
    name :: String
  }
  
  define page pagearg(u:User,s:String,i:Int,f:Float,b:Bool)
  {
    form{
      if(true)
      {
        input(i)
      }
      action("save",someaction(i,u))
    }
    
    action someaction(i:Int,u:User){
      var temp : Int := i;
      var user : User := u;
    }
  }

  define page home(){
    var u:User := User{};
    var s:String;
    var i:Int;
    var f:Float;
    var b:Bool;    
 
    output(u.name)
    input(s)
    output(s)
    input(i)
    output(i)
    input(f)
    output(f)
    input(b)
    output(b)

    
    div("test")
    {
      input(b)
    }
    
    div("test")
    {
      input(b)
      input(s)
      input(i)
    }
    
    block("test")
    {
    
    }
    
    
    //spacer
    spacer()
    horizontalspacer()
    
    //title
    title{"dsdfssf"}
    
    
    
    
    //section header par container
    section{
      header{
        "header"
      }
      "kfakjdkfjkad"
      section{
        header{
          "sdfasdfasf"
        }
        "sdfasdfasf"
        section{
          header{
            "asfr23rewrw"
          }
          "fdaffawf"
          par{
            "par"
          }
          container{
            "container"
          }
        }
      }
    }
    
    
    //table header row
    table{
      row{header{"header1"}"row1"}
      row{header{"header2"}"row2"}
      row{header{"header3"}"row3"}
      row{header{"header4"}"row4"}
    }
    
    if(true){
      "true"
    }
    if(false){
      "false"
    }  
    form{
      input(i)
      input(b)
      action("save",someaction())
    }
    
    action someaction(){
      var temp : Int := i;
    
    }
    
  }


