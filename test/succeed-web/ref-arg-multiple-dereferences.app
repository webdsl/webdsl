application test

  entity MessageInBox{
    message->Message    
  }
  entity Message{
    sentAt::DateTime
    message->Message
  }
  
  var globalmbox :=
    MessageInBox{ 
      message := 
        Message{ 
          sentAt := DateTime("01/01/2011 11:50") 
          message := Message{ message:=Message{ sentAt := DateTime("12/12/2012 12:12") } }  
        } 
    }
  
  define span messageHeader(m : MessageInBox) {
    row{
      column{ output(m.message.sentAt) }
    }
  }
  
  define span messageHeader2(m : MessageInBox) {
    row{
      column{ output(m.message.message.message.sentAt) }
    }
  }

  define page root() {
    messageHeader(globalmbox)
    messageHeader2(globalmbox)
  }
  
  test {
    var d : WebDriver := getHtmlUnitDriver();

    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("01/01/2011 11:50"));
    assert(d.getPageSource().contains("12/12/2012 12:12"));
  }
  