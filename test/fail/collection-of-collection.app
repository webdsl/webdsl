//#2 'for' without 'in' can only iterate over a defined entity type

application test

  entity Book{}

  define page root(){
    for(book:List<Book>){
      output(book)
    }
    for(book:Set<Book> where book != null){
      output(book)
    }
  }

