module .servletapp/src-webdsl-template/built-in

  section methods for built-in types

  type String { //includes other String-based types such as Secret, Patch, Email, URL, etc.
    length():Int
    toLowerCase():String
    toUpperCase():String
    replace(String,String):String
    startsWith(String):Bool
    startsWith(String,Int):Bool
    endsWith(String):Bool
    utils.StringType.parseUUID                   as parseUUID():UUID
    org.webdsl.tools.Utils.containsDigit         as containsDigit():Bool
    org.webdsl.tools.Utils.containsLowerCase     as containsLowerCase():Bool
    org.webdsl.tools.Utils.containsUpperCase     as containsUpperCase():Bool
    org.webdsl.tools.Utils.isCleanUrl            as isCleanUrl():Bool
    org.apache.commons.lang.StringUtils.contains as contains(String):Bool // this 'contains' function handles null, null as either arg will produce false 
    utils.StringType.parseInt                    as parseInt():Int
    utils.StringType.split                       as split():List<String>
    utils.StringType.splitWithSeparator          as split(String):List<String> //TODO Regex as argument
    utils.StringType.parseLong                   as parseLong():Long
    utils.StringType.parseFloat                  as parseFloat():Float
    utils.DateType.parseDate as parseDate(String):Date
    utils.DateType.parseDate as parseDateTime(String):DateTime
    utils.DateType.parseDate as parseTime(String):Time
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
  
  native class utils.DateType as DateType{ //@TODO static functions not yet supported in type import of DateTime above
    static getDefaultDateFormat():String
    static getDefaultTimeFormat():String
    static getDefaultDateTimeFormat():String
  }
  
  type WikiText{
    org.webdsl.tools.WikiFormatter.wikiFormat as format():String
  }
  
  type Email {
    utils.EmailType.isValid as isValid():Bool
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
    static className(String):SelectBy
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
  
  // logging       
  
  entity RequestLogEntry {
    name :: String
    params -> List<RequestLogEntryParam>
    requestedURL :: String (length=1000000)
    start :: DateTime
    end :: DateTime
    clientIP :: String
    clientPort :: Int
    method :: String
    referer :: String  (length=1000000)
    userAgent :: String
    queryExecutionCount :: Int
    queryExecutionMaxTime :: Int
    queryExecutionMaxTimeQueryString :: String
  }
  
  entity RequestLogEntryParam {
    name :: String
    value :: String
  }
  
  //built-in templates
  
  define ignore-access-control break(){
    <br all attributes/>
  }
  /*
  define ignore-access-control block(){
    <div class="block "+attribute("class") 
         all attributes except "class">
      elements()
    </div>
  }*/
  
  define ignore-access-control div(){
    <div all attributes>
      elements()
    </div>
  }
  
  define ignore-access-control container(){
    <span class="container "+attribute("class") 
         all attributes except "class">
      elements()
    </span>
  }
  
  define ignore-access-control fieldset(s:String){
    <fieldset all attributes>
      <legend>
        output(s)
      </legend>
      elements()
    </fieldset>
  }
  
  define ignore-access-control group(s:String){
    <fieldset all attributes>
      <legend>
        output(s)
      </legend>
      <table>
        elements()
      </table>
    </fieldset>
  }
  
  define ignore-access-control group(){
    <fieldset class="fieldset_no_legend_ "+attribute("class") 
      all attributes except "class">
      <table>
        elements()
      </table>
    </fieldset>
  }

  define ignore-access-control groupitem(){
    <tr all attributes>
      elements()
    </tr>
  }
 
  define ignore-access-control table(){
    <table all attributes>
      elements()
    </table>	
  }
  
  define ignore-access-control row(){
    <tr all attributes>
      elements()
    </tr>	
  }
  
  define ignore-access-control column(){
    <td all attributes>
      elements()
    </td>	
  }
  
  /*
  define ignore-access-control list(){
    <ul all attributes>
      elements()
    </ul>
  }
  
  define ignore-access-control listitem(){
    <li all attributes>
      elements()
    </li>
  }
  */
  
  define ignore-access-control par(){
    <p all attributes>
      elements()
    </p>
  }
  
  define ignore-access-control pre(){
    <pre all attributes>
      elements()
    </pre>
  }
  
  define ignore-access-control spacer(){
    <hr all attributes/>
  }
  
  /*
    menubar{
      menu
      {
        menuheader{ ... }
        menuitems{
          menuitem{ ... }
          menuitem{ ... }
        }
      }
    }
  */
  
  define ignore-access-control menubar(){
    var elementid := "menu"+getUniqueTemplateId()
    includeCSS("dropdownmenu.css")
    <div class="menuwrapper" id=elementid all attributes>
      <ul id="p7menubar" class="menubar">
        elements()
      </ul>
    </div>
  }

  define ignore-access-control menuspacer(){
    <li all attributes>
      elements()
    </li>
  }
  
  define ignore-access-control menu(){
    <li class="menu" all attributes>
      elements()
    </li>
  }
  
  define ignore-access-control menuheader(){
    <span class="menuheader" all attributes>
      elements()
    </span>
  }
  
  define ignore-access-control menuitems(){
    <ul class="menuitems">
      elements()
    </ul>
  }
  
  define ignore-access-control menuitem(){
    <li class="menuitem" all attributes>
      elements()
    </li>
  }

  //reflection of entities
  
  native class utils.ReflectionEntity as ReflectionEntity{
    getName():String
    getProperties():List<ReflectionProperty>
    getPropertyByName(String):ReflectionProperty
  }

  native class utils.ReflectionProperty as ReflectionProperty{
    getName() : String
    hasNotNullAnnotation() : Bool	
    getFormatAnnotation() : String
  }
  
  //validation wrapper for submit and submitlink
  
  define ignore-access-control wrapsubmit(tname:String) requires s(String){
    if(getValidationErrorsByName(tname).length > 0){
      errorTemplateAction(getValidationErrorsByName(tname)){
        s(tname)
      }
    }
    else{
      s(tname)
    }
  }
  
  //reused when elements() are empty
  
  define ignore-access-control elementsempty(){}
  
  // Date/DateTime/Time input and output templates
  
  define ignore-access-control output(d:Ref<DateTime>){
    var default := DateType.getDefaultDateTimeFormat();
    dateoutputgeneric(d as Ref<Date>, default)[all attributes]
  }
  
  define ignore-access-control output(d:Ref<Time>){
    var default := DateType.getDefaultTimeFormat();
    dateoutputgeneric(d as Ref<Date>, default)[all attributes]
  }
  
  define ignore-access-control output(d:Ref<Date>){
    var default := DateType.getDefaultDateFormat();
    dateoutputgeneric(d,default)[all attributes]
  }
  
  define ignore-access-control dateoutputgeneric(d:Ref<Date>, defaultformat : String){
    var dateformat := defaultformat;
    init{
      //@TODO add support for ref arg in function, to avoid repeating this in both output and input
      var attr := attribute("format");
      if(attr!=null && attr != ""){
        dateformat := attr;
      }
      else{
        if(d.getReflectionProperty() != null){
          var formatanno := d.getReflectionProperty().getFormatAnnotation();
          if(formatanno!=null){
            dateformat := formatanno;
          }
        }
      }
    }
    output(d.format(dateformat))
  }
  
  define ignore-access-control input(d:Ref<DateTime>){
    var format := DateType.getDefaultDateTimeFormat()
    var dateformatString := ""
    var timeformatString := ""
    init{
      var attr := attribute("format");
      if(attr!=null && attr != ""){
        format := attr;
      }
      else{
        if(d.getReflectionProperty() != null){
          var formatanno := d.getReflectionProperty().getFormatAnnotation();
          if(formatanno!=null){
            format := formatanno;
          }
        }
      }
      var tmp := format.split(" "); //assumes date and time are separated by space and no other spaces in the format string
      dateformatString := "dateFormat: '"+convertDateFormatToJQuery(tmp[0])+"', ";
      timeformatString := "timeFormat: '"+convertTimeFormatToJQuery(tmp[1])+"', ";
    }
    dateinputgeneric(d as Ref<Date>, format, "datetimepicker", dateformatString+timeformatString+" changeMonth: true, changeYear: true, yearRange: '1900:new Date().getFullYear()'")[all attributes]
  }
  
  define ignore-access-control input(d:Ref<Time>){
    var format := DateType.getDefaultTimeFormat()
    var timeformatString := ""
    init{
      var attr := attribute("format");
      if(attr!=null && attr != ""){
        format := attr;
      }
      else{
        if(d.getReflectionProperty() != null){
          var formatanno := d.getReflectionProperty().getFormatAnnotation();
          if(formatanno!=null){
            format := formatanno;
          }
        }
      }
      timeformatString := "timeFormat: '"+convertTimeFormatToJQuery(format)+"'";
    }
    dateinputgeneric(d as Ref<Date>, format, "timepicker", timeformatString)[all attributes]
  }

  function convertTimeFormatToJQuery(f:String):String{
    return f.replace("H","h");
  }
  function convertDateFormatToJQuery(f:String):String{
    return f.replace("yyyy","yy").replace("MM","mm");
  }

  define ignore-access-control input(d:Ref<Date>){
    var format := DateType.getDefaultDateFormat()
    var dateformatString := ""
    init{
      var attr := attribute("format");
      if(attr!=null && attr != ""){
        format := attr;
      }
      else{
        if(d.getReflectionProperty() != null){
          var formatanno := d.getReflectionProperty().getFormatAnnotation();
          if(formatanno!=null){
            format := formatanno;
          }
        }
      }
      dateformatString := "dateFormat: '"+convertDateFormatToJQuery(format)+"', ";
    }
    dateinputgeneric(d, format, "datepicker", dateformatString+" changeMonth: true, changeYear: true, yearRange: '1900:new Date().getFullYear()'")[all attributes]
  }
  
  define ignore-access-control dateinputgeneric(d:Ref<Date>, dateformat : String, picker : String, options:String){
    var tname := getUniqueTemplateId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        datepickerinput(d,dateformat,tname,picker,options)[all attributes]
      }
    }
    else{
      datepickerinput(d,dateformat,tname,picker,options)[all attributes]
    }
    validate{
      if(req != null){
        if(req!="" && req.parseDate(dateformat)==null){
          errors := ["Incorrect date format, expected format is "+dateformat];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := d.getValidationErrors();
      }
      if(errors != null && errors.length > 0){
        if(inLabelContext()){
          for(s:String in errors){
            addLabelError(s);
          }
          errors := null;
        }
        cancel();
      }      
    }
  }

  define ignore-access-control datepickerinput(d:Ref<Date>, dateformat:String, tname:String, picker:String, options : String){
    var s : String
    init{ 
      if(d==null){
        s := "";
      }
      else{
        s := d.format(dateformat);
      }
    }

    //includeJS("https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js")
    //includeJS("https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/jquery-ui.min.js")
    //includeCSS("http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css")
    includeJS("jquery-1.5.min.js")
    includeJS("jquery-ui-1.8.9.custom.min.js")
    includeJS("jquery-ui-timepicker-addon.js")
    includeCSS("jquery-ui-1.8.9.custom.css")
    includeCSS("jquery-ui-timepicker-addon.css")
    
    var req := getRequestParameter(tname)
    
    <input 
      if(inLabelContext()) { 
        id=getLabelString() 
      } 
      name=tname
      type="text"
      if(req != null){ 
        value = req 
      }
      else{
        value = s
      }
      class="inputDate "+attribute("class") 
      all attributes except "class"
    />

    //uses setTimeout which seems to give better results when used in combination with webdsl ajax
    <script>
      setTimeout("$('input[name=~tname]').~picker({~options})",500); 
    </script>
 
    databind{
      if(req != null){
        if(req==""){
          d := null;
        }        
        else{
          var newdate := req.parseDate(dateformat);
          if(newdate != null){
            d := newdate;
          }
        }
      }
    }
  }  
  
  //default access control rule
  
  access control rules
  
    rule template *(*){true}
    