application test


  define page root() {
    navigate(test()){ "test mimetype" }
    navigate(testraw()){ "test rawoutput" }
  }
  
  define page test(){
    mimetype("text/plain")
    "1 && 2 <> 3"
  }

  define page testraw(){
    var s : String := "&'\"&<><>"
    rawoutput{
      "&'\"&<><>" 
      output(s)
    }
    output(s)
  }
