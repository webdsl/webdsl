application takescreenshot
  
  page root() {
    <div style="color:blue;">
      "hello world"
    </div>
  }
      
  test {
    var d := getFirefoxDriver();
    d.get(navigate(root()));
    
    d.takeScreenshot();
    d.takeScreenshot();
    d.takeScreenshot();
    d.takeScreenshot();
  }
