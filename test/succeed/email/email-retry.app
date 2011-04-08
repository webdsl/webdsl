application test

  define email testemail(to:String,from:String,subject:String) {
    to(to)
    from(from)
    subject(subject)
    "test email"
  }
  
  define page root() {

  }
  
  function sendit(){
    email testemail("","","");
  }

  native class Thread {
    static sleep(Int)
  }

  test emailfail {
    
    sendit();

    var queuedEmails := from QueuedEmail;
    assert(queuedEmails[0].lastTry == null);
    
    internalHandleEmailQueue();
    
    var queuedEmails1 := from QueuedEmail;
    var tstamp := queuedEmails1[0].lastTry;
    log(tstamp != null);
    
    internalHandleEmailQueue();
    
    Thread.sleep(2000);
    
    var queuedEmails2 := from QueuedEmail;
    assert(queuedEmails2[0].lastTry == tstamp); // should not have changed, too early for retry
    
    queuedEmails2[0].lastTry := tstamp.addHours(-2);
    internalHandleEmailQueue();
    var queuedEmails3 := from QueuedEmail;
    assert(queuedEmails3[0].lastTry == tstamp.addHours(-2)); // should not have changed, too early for retry
    
    queuedEmails2[0].lastTry := tstamp.addHours(-4);
    internalHandleEmailQueue();
    var queuedEmails4 := from QueuedEmail;
    assert(queuedEmails4[0].lastTry != tstamp.addHours(-4)); // should have changed
  }