module built-in

  section methods for built-in types

  type String { //includes other String-based types such as Secret, Patch, Email, URL, etc.
    length():Int
    toLowerCase():String
    toUpperCase():String
    replace(String,String):String
    utils.StringType.parseUUID                   as parseUUID():UUID
    org.webdsl.tools.Utils.containsDigit         as containsDigit():Bool
    org.webdsl.tools.Utils.containsLowerCase     as containsLowerCase():Bool
    org.webdsl.tools.Utils.containsUpperCase     as containsUpperCase():Bool
    org.webdsl.tools.Utils.isCleanUrl            as isCleanUrl():Bool
    org.apache.commons.lang.StringUtils.contains as contains(String):Bool // this 'contains' function handles null, null as either arg will produce false 
    utils.StringType.parseInt                    as parseInt():Int
    utils.StringType.split                       as split():List<String>
    utils.StringType.splitWithSeparator          as split(String):List<String> //TODO Regex as argument
  }
  
  type Secret {
    org.webdsl.tools.Utils.secretDigest  as digest():Secret
    org.webdsl.tools.Utils.secretCheck   as check(Secret):Bool
  }
  
  type Patch {
    name.fraser.neil.plaintext.patch_factory.patchApply  as applyPatch(String):String
  }
  type String {
    name.fraser.neil.plaintext.patch_factory.patchMake   as makePatch(String):Patch
    name.fraser.neil.plaintext.patch_factory.diff        as diff(String):List<String>
  }
  
  type DateTime { // includes Date and Time types
    utils.DateType.format as format(String):String
    before(DateTime):Bool
    after(DateTime):Bool
    getTime():Long
    setTime(Long)
  }

//  section JSON for services
      
  native class org.json.JSONObject as JSONObject {
    constructor()
    constructor(String)
    get(String) : Object
    getBoolean(String) : Bool
    getDouble(String) : Double
    getInt(String) : Int
    getJSONArray(String) : JSONArray
    getJSONObject(String) : JSONObject
    getString(String) : String
    has(String) : Bool
    names() : JSONArray
    put(String, Object)
    toString() : String
    toString(Int) : String
  }
  
  native class org.json.JSONArray as JSONArray {
    constructor()
    constructor(String)
    get(Int) : Object
    getBoolean(Int) : Bool
    getDouble(Int) : Double
    getInt(Int) : Int
    getJSONArray(Int) : JSONArray
    getJSONObject(Int) : JSONObject
    getString(Int) : String
    length() : Int
    join(String) : String
    put(Object)
    remove(Int)
    toString() : String
    toString(Int) : String
  } 
  
//  section WebDriver for testing
  
  native class org.openqa.selenium.WebDriver as WebDriver {
    get(String)
    getTitle():String
    getPageSource():String
    findElement(SelectBy):WebElement
    findElements(SelectBy):List<WebElement>
    close()
  }
  
  native class org.openqa.selenium.By as SelectBy {
    static id(String):SelectBy
    static linkText(String):SelectBy
    static name(String):SelectBy
    static partialLinkText(String):SelectBy
    static tagName(String):SelectBy
    static xpath(String):SelectBy
  } 
  
  native class org.openqa.selenium.WebElement as WebElement {
    getText():String
    getValue():String
    getElementName():String
    isEnabled():Bool
    sendKeys(String)
    submit()
    clear()
    click()
    getAttribute(String):String
    isEnabled():Bool
    isSelected():Bool
    //void 	sendKeys(java.lang.CharSequence... keysToSend)
    setSelected()
    toggle():Bool
  }
  
  native class org.openqa.selenium.htmlunit.HtmlUnitDriver as HtmlUnitDriver : WebDriver {
    constructor()
  }
  
  native class org.openqa.selenium.firefox.FirefoxDriver as FirefoxDriver : WebDriver {
    constructor()
  }
  
//email

  entity QueuedEmail {
    body :: String (length=1000000) //Note: default length for string is currently 255
    to :: String (length=1000000)
    cc :: String (length=1000000)
    bcc :: String (length=1000000)
    replyTo :: String (length=1000000)
    from :: String (length=1000000)
    subject :: String (length=1000000)
  }
  
  invoke internalHandleEmailQueue() every 30 seconds

  function internalHandleEmailQueue(){
    var queuedEmails := from QueuedEmail limit 5;
    
    for(queuedEmail:QueuedEmail in queuedEmails){
      queuedEmail.delete();
      flush();
      sendemail(sendQueuedEmail(queuedEmail));
      //normally you would use email(sendQueuedEmail(queuedEmail)) to send email, however, 
      //that is desugared to renderemail(queuedEmail).save() to make it asynchronous.
      //In this function the email is actually send, using the synchronous sendemail function.
    }
  }
  
  define email sendQueuedEmail(q:QueuedEmail){
    to(q.to)
    from(q.from)
    subject(q.subject)
    cc(q.cc)
    bcc(q.bcc)
    replyTo(q.replyTo)
    rawoutput{ //don't escape the html from internal email rendering
      output(q.body)
    }
  }
  
// radio buttons input

  define ignore-access-control validate radio(ent1:Ref<Entity>,ent2:List<Entity>){
    var rname := getUniqueTemplateId()
    var tmp : String:= getRequestParameter(rname);
    var subme : Entity := null;
    init{
      if(tmp != null){
        subme := loadEntity(ent1.getTypeString(),UUIDFromString(tmp));
      }
    }
    for(e:Entity in ent2){
      <input type="radio"
        //either it was submitted or it was not submitted but the value was already p
        if(tmp != null && subme == e || tmp == null && ent1 == e){
           checked="checked"
        }
        name=rname
        value=e.id
        all attributes
      />
      output(e.name)
    }
    databind{
      if(tmp != null && subme in ent2){
        ent1 := subme;
      }
    }
  }