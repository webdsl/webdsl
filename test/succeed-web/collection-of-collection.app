application test

  entity Book {
    title :: String
  }

  var b1 := Book{title := "1"}
  var b2 := Book{title := "2"}
  var b3 := Book{title := "3"}
  
  define no-span output(b:Book){
    output(b.title)
  }
  
  define page root(){
    bla([[b1,b2,b3]])
    bla4([{[{b1,b2}]}])
    output(blafunc([{[{b1,b2}]}]))
  }
  
  define no-span bla(books:List<List<Book>>){
    for(list: List<Book> in books){
      for(book:Book in list){
        output(book)
      }
    }
  }

  define no-span bla4(books: List<Set<List<Set<Book>>>>){
    for(i: Set<List<Set<Book>>> in books){
    for(j: List<Set<Book>> in i){
    for(k: Set<Book> in j){
    for(l: Book in k){
        output(l)
    }}}}
  }
  function blafunc(books: List<Set<List<Set<Book>>>>):String{
    var s := "";
    for(i: Set<List<Set<Book>>> in books){
    for(j: List<Set<Book>> in i){
    for(k: Set<Book> in j){
    for(l: Book in k){
        s := s+l.title;
    }}}}
    return s;
  }
  
  test buttonclick {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    
    assert(!(d.getPageSource().contains("404")), "redirect may not produce a 404 error");
    assert(d.getPageSource().contains("1231212"), "incorrect output");
    
    d.close();
  }
  