application test


  define page home() {
    navigate(test()){ "test mimetype" }
  }
  
  define page test(){
    mimetype("text/plain")
    "1"
  }
