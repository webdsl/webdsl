application t

page root(){
  submit action{ Test{ s := "error" }.save(); rollback();  }{ "rollback" }
  submit action{ Test{ s := "testvalue123" }.save(); }{ "commit" }
  
  for(t:Test order by t.s){
    output(t.s)
  }
}

entity Test{
  s: String
}


request var s : String

function check(){
  log(s);
}

function afterTransactionBegin(){
  s := "begin.";
  check();
}
 
function afterTransactionCompletionCommitted(){
  s := "committed.";
  check();
}

function afterTransactionCompletionRolledBack(){
  s := "rolledback.";
  check();
}

function beforeTransactionCompletion(){
  s := "beforecompletion.";
  check();
}

test{
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate( root() ));
    
  d.getSubmits()[0].click();
  d.getSubmits()[1].click();

  assert(d.getPageSource().split("testvalue123").length == 2);
}

  