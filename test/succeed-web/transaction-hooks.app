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
entity Submission{}

request var globalrv : String
request var testSet := Set<Submission>()

function check(){
  log(globalrv);
  testSet.add(Submission{});
}

function afterTransactionBegin(){
  globalrv := "begin.";
  check();
}
 
function afterTransactionCompletionCommitted(){
  globalrv := "committed.";
  check();
}

function afterTransactionCompletionRolledBack(){
  globalrv := "rolledback.";
  check();
}

function beforeTransactionCompletion(){
  globalrv := "beforecompletion.";
  check();
}

test{
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate( root() ));
    
  d.getSubmits()[0].click();
  d.getSubmits()[1].click();

  assert(d.getPageSource().split("testvalue123").length == 2);
}

  