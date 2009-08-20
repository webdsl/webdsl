application test

  entity Journal{
    title :: String
  }
  
  var j_1 := Journal { title := "journal 1" }
  
  entity Paper{
    title :: String (id)
  }
  
  var p_1 := Paper { title := "paper 1" }
  
  define page root(){
    output(loadEntity("Journal",j_1.id) as Journal)
    output(loadEntity("Paper",p_1.id) as Paper)
    output(loadJournal(j_1.id))
    output(loadPaper(p_1.title))
  }
  
  define page journal(j:Journal){
    "Journal"
    label("Title: "){ output(j.title) }
  }
  define page paper(p:Paper){
    "Paper"
    label("Title: "){ output(p.title) }
  }
