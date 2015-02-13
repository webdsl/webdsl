application test

section datamodel

  entity User{
    name :: String
  }
  
  define page pagearg(u:User,s:String,i:Int,f:Float,b:Bool)
  {
    var temp: Int := i;
    form{
      if(true)
      {
        input(temp)
      }
      action("save",someaction(temp,u))
    }
    
    action someaction(i1:Int,u1:User){
      var temp1 : Int := i1;
      var user : User := u1;
    }
  }

  define page root(){
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

    
    div
    {
      input(b)
    }
    
    div
    {
      input(b)
      input(s)
      input(i)
    }
    
    block("test")
    {
    
    }
    
    
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
    
    
    
    
    //lists
    
    list{
      listitem{"1"}
      listitem{"2"}
      listitem{"3"}
    }
    
  }


