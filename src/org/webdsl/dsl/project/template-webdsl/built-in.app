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
    org.apache.commons.lang.StringEscapeUtils.escapeJavaScript as escapeJavaScript():String
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
    utils.DateType.addYears as addYears(Int):DateTime
    utils.DateType.addMonths as addMonths(Int):DateTime
    utils.DateType.addDays as addDays(Int):DateTime
    utils.DateType.addHours as addHours(Int):DateTime
    utils.DateType.addMinutes as addMinutes(Int):DateTime
    utils.DateType.addSeconds as addSeconds(Int):DateTime
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
  
  type File{
    getContentAsString():String
  }
  type Image{
    getContentAsString():String
  }
  
// access to page context

  native class AbstractPageServlet as PageServlet {
    inSubmittedForm() : Bool
    formRequiresMultipartEnc : Bool
    getFileUpload(String) : File  
    getLabelString() : String
    inLabelContext() : Bool
    addValidationException(String,String)
    getValidationErrorsByName(String):List<String>
    static getRequestedPage() : PageServlet
    enterLabelContext(String)
    leaveLabelContext()
    setTemplateContext(TemplateContext)
    getTemplateContext():TemplateContext
    getIncomingSuccessMessages():List<String>
    clearIncomingSuccessMessages()
  }
  function getPage():PageServlet{
    return PageServlet.getRequestedPage();
  }  
  
  native class utils.TemplateContext as TemplateContext {
    clone():TemplateContext
    getTemplateContextString():String
  }

//access to template context
  
  native class TemplateServlet as TemplateServlet {
    getUniqueId() : String
    static getCurrentTemplate() : TemplateServlet
  }
  function getTemplate() : TemplateServlet{
    return TemplateServlet.getCurrentTemplate();
  }  
  
// utitity for templates that handle validation

  function handleValidationErrors(errors : List<String>): List<String>{
    var result :List<String> := null;
    if(errors != null && errors.length > 0){
      if(getPage().inLabelContext()){
        for(s:String in errors){
          getPage().addValidationException(getPage().getLabelString(),s);
        }
      }
      else{
        result := errors;
      }
      cancel();
    }    
    return result;
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
  
  native class org.openqa.selenium.support.ui.Select as Select {
    deselectAll() // Clear all selected entries.
    deselectByIndex(Int) // Deselect the option at the given index.
    deselectByValue(String) // Deselect all options that have a value matching the argument.
    deselectByVisibleText(String) // Deselect all options that display text matching the argument.
    escapeQuotes(String):String
    getAllSelectedOptions():List<WebElement>
    getFirstSelectedOption():WebElement
    getOptions():List<WebElement>
    isMultiple():Bool
    selectByIndex(Int) // Select the option at the given index.
    selectByValue(String) // Select all options that have a value matching the argument.
    selectByVisibleText(String) // Select all options that display text matching the argument.
    constructor(WebElement)
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
    lastTry :: DateTime 
  }
  
  invoke internalHandleEmailQueue() every 30 seconds

  function internalHandleEmailQueue(){
    var n : DateTime := now().addHours(-3); // retry after 3 hours to avoid spamming too much
    var queuedEmails := from QueuedEmail as q where q.lastTry is null or q.lastTry < ~n limit 1;
    
    for(queuedEmail:QueuedEmail in queuedEmails){
      if(sendemail(sendQueuedEmail(queuedEmail))){
        queuedEmail.delete();    
      }
      else{
        queuedEmail.lastTry := now();
      }
      
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

  define ignore-access-control radio(ent1:Ref<Entity>,ent2:List<Entity>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        radioInternal(ent1, ent2, tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      radioInternal(ent1, ent2, tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := ent1.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);       
    }
  }

  define ignore-access-control radioInternal(ent1:Ref<Entity>,ent2:List<Entity>, tname : String){
    var tmp : String:= getRequestParameter(tname);
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
        name=tname
        value=e.id
        id=tname+e.id
        all attributes
      />
      <label for=tname+e.id>
        output(e.name)
      </label>
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
    var elementid := "menu"+getTemplate().getUniqueId()
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
  
  native class org.webdsl.lang.ReflectionEntity as ReflectionEntity{
    getName():String
    getProperties():List<ReflectionProperty>
    getPropertyByName(String):ReflectionProperty
    hasViewPage():Bool
    static byName(String):ReflectionEntity
    static all():List<ReflectionEntity>
  }
  
  native class org.webdsl.lang.ReflectionProperty as ReflectionProperty{
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
    dateinputgeneric(d as Ref<Date>, format, "datetimepicker", dateformatString+timeformatString+" changeMonth: true, changeYear: true, yearRange: '1900:new Date().getFullYear()'")[all attributes]{elements()}
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
    dateinputgeneric(d as Ref<Date>, format, "timepicker", timeformatString)[all attributes]{elements()}
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
    dateinputgeneric(d, format, "datepicker", dateformatString+" changeMonth: true, changeYear: true, yearRange: '1900:new Date().getFullYear()'")[all attributes]{elements()}
  }
  
  define ignore-access-control dateinputgeneric(d:Ref<Date>, dateformat : String, picker : String, options:String){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        datepickerinput(d,dateformat,tname,picker,options)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      datepickerinput(d,dateformat,tname,picker,options)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      if(req != null){
        if(req!="" && req.parseDate(dateformat)==null){
          errors := ["Incorrect date format, expected format is "+dateformat];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := d.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      }
      errors := handleValidationErrors(errors);       
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
    includeCSS("jquery-ui.css")
    includeCSS("jquery-ui-timepicker-addon.css")
    
    var req := getRequestParameter(tname)
    
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
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
  
  //output(Set)
  /*
  define output(set : Set<Entity>){
    <ul all attributes>
      for(e:Entity in set order by e.name){
        <li>
          output(e)
        </li>
      }
    </ul>
  }
  */
  //input(Set<Entity>) 
  /*
  define input(set:Ref<Set<Entity>>){
    input(set, set.getEntity())
  }*/
  
 define input(set:Ref<Set<Entity>>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null

    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputCheckboxSetInternal(set,from,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputCheckboxSetInternal(set,from,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := set.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);
    }
  }
  
  define inputCheckboxSetInternal(set : Ref<Set<Entity>>, from : List<Entity>, tname:String){
    var tnamehidden := tname + "_isinput"
    var reqhidden := getRequestParameter(tnamehidden)
    request var tmpset := Set<Entity>()
    
    <div class="checkbox-set "+attribute("class") all attributes except ["class","onclick"]>
      <input type="hidden" name=tnamehidden /> 
      for(e:Entity in from){
        inputCheckboxSetInternalHelper(set,tmpset,e,tname+"-"+e.id)[onclick=""+attribute("onclick")]
      }
    </div>
    databind{
      if(reqhidden != null){
        set := tmpset;
      }
    }
  }

  define inputCheckboxSetInternalHelper(set:Ref<Set<Entity>>, tmpset:Set<Entity>,e:Entity,tname:String){
    var tmp := getRequestParameter(tname)
    var tnamehidden := tname + "_isinput"
    var tmphidden := getRequestParameter(tnamehidden)
    <div class="checkbox-set-element">
      <input type="hidden" name=tnamehidden />
      <input type="checkbox" 
        name=tname 
        if(tmphidden!=null && tmp!=null || tmphidden==null && e in set){
          checked="true"  
        }
        all attributes
      />
      output(e.name)
    </div>
    databind{
      if(tmphidden != null && tmp != null){ tmpset.add(e); }
    }
  }
  
  
  //input(e:Entity)
  
  define input(ent : Ref<Entity>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputEntityInternal(ent,from,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputEntityInternal(ent,from,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := ent.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);
    }
  }

  define inputEntityInternal(ent : Ref<Entity>, from : List<Entity>, tname:String){
    var rnamehidden := tname + "_isinput"
    var reqhidden := getRequestParameter(rnamehidden)
    var req : String := getRequestParameter(tname)
    var notnull := hasNotNullAttribute() || (ent.getReflectionProperty()!=null&&ent.getReflectionProperty().hasNotNullAnnotation())
    <input type="hidden" name=tname+"_isinput" />
    <select 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      class="select "+attribute("class") 
      all attributes except "class"
    >
      if(!notnull){
        <option value="none"
          if(reqhidden!=null && req==null || reqhidden==null && ent == null){ 
            selected="selected"
          }
        ></option>
      }
      for(e:Entity in from){
        <option 
          value=e.id
          if(reqhidden!=null && req!=null && e.id.toString() == req || reqhidden==null && e == ent){ 
            selected="selected"
          }
        >
          output(e.name)
        </option>  
      }
    </select>
  
    databind{
      if(reqhidden != null){
        if(!notnull && req == "none"){
          ent := null;
        }
        else{
          var fromids := [ e | e:Entity in from where e.id.toString()==req ];
          if(fromids.length > 0){
            ent := fromids[0]; // check with 'from' list to make sure that it was an option, to protect against tampering
          }
        }
      }
    }
  }  
  
  //output(Entity)
  /*
  define output(e:Entity){
    var hasviewpage := false;
    var viewpagename := "";
    init{
      var type := e.getTypeString();
      hasviewpage := ReflectionEntity.byName(type).hasViewPage();
      viewpagename := type.toLowerCase();
    }
    if(hasviewpage){
      //not possible yet
      navigate ~viewpagename((~type) e){ output(e.name) } 
    }
    else{
      output(e.name)
    }
  }*/
  
  
  //output(List)
  /*
  define output(list : List<Entity>){
    <ol all attributes>
      for(e:Entity in list){
        <li>
          output(e)
        </li>
      }
    </ol>
  }
  */
  // input(List)
  
  define input(list:Ref<List<Entity>>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputListInternal(list,from,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputListInternal(list,from,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := list.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);
    }
  }  
    
  function updateListRequest(request:String, list:List<Entity>,selectfrom : List<Entity>): List<Entity>{
    if(request == null){ // nothing submitted
      return list;
    }
    var elementids := request.split(",");
    var options := List<Entity>();
    options.addAll(list);
    options.addAll(selectfrom);
    var newlist := List<Entity>();
    for(s:String in elementids){
      var ent := [e | e:Entity in options where e.id.toString() == s];
      if(ent.length > 0){
        var selected := ent[0];
        newlist.add(selected);
      }
    }
    return newlist;
  }  
    
  define inputListInternal(list: Ref<List<Entity>>, selectfrom : List<Entity>, tname:String){
    var hiddenid := "hidden"+tname
    var sortableid := "sortable"+tname
    var selectid := "select"+tname
    var tmp := getRequestParameter(hiddenid);
    var newlist := updateListRequest(tmp,list,selectfrom);
    var onchange := attribute("onchange");
    var deletejsfuncname := "delete"+tname;
    databind {
      list := newlist;
    }
    
    includeCSS("jquery-ui.css")
    includeJS("jquery-1.5.min.js")
    includeJS("jquery-ui-1.8.9.custom.min.js")
    
    <script type="text/javascript">
      $(function() {
        $('#~sortableid').sortable();
        $('#~sortableid').disableSelection();
        $('#~sortableid').sortable({
              stop: function(event, ui){ 
                $('#~hiddenid').attr('value', $('#~sortableid').sortable('toArray'));
                ~onchange
              }
          });
          //initial values
          $('#~hiddenid').attr('value', $('#~sortableid').sortable('toArray'));
          //optional stuff
          //constrain dragging to list
          //$('#~sortableid').sortable( "option", "containment", 'parent' );
      });
      var ~deletejsfuncname = function(dollarthis){
        dollarthis.parent().remove(); 
        $('#~hiddenid').attr('value', $('#~sortableid').sortable('toArray'));
        ~onchange      	
      };
    </script>
    <input type="hidden" name=hiddenid id=hiddenid/>
    <ul id=sortableid class="sortable">
      for(e:Entity in newlist){
        <li id=e.id class="ui-state-default">
          <span class="ui-icon ui-icon-arrowthick-2-n-s"></span>
          output(e.name)
          <span class="ui-icon ui-icon-close" onclick=deletejsfuncname+"($(this));"></span>
        </li>	 
      }
    </ul>
    
    //@TODO should become possible to re-use render of template in client
    var p1 := "<li id=\""
    var p2 := "\" class=\"ui-state-default\"><span class=\"ui-icon ui-icon-arrowthick-2-n-s\"></span>" 
    var p3 := "<span class=\"ui-icon ui-icon-close\" onclick=\""+deletejsfuncname+"($(this));\"></span></li>"

    if(selectfrom.length > 0){
      <select id=selectid>
      for(e:Entity in selectfrom){
        <option value=e.id>
          output(e.name)
        </option>
      }
      </select>
      
      <input type="button" value="add" 
        onclick="$('select#"+selectid+" option:selected').each(function(){ $('#"+sortableid+"').append('"+p1+"'+$(this).attr('value')+'"+p2+"'+$(this).html()+'"+p3+"');}); $('#"+hiddenid+"').attr('value', $('#"+sortableid+"').sortable('toArray')); "+onchange+"return false;" />
    }
  }   
  
  
  
  //select multiple
  
  define select(set:Ref<Set<Entity>>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputSelectMultipleInternal(set,from,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputSelectMultipleInternal(set,from,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := set.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);
    }
  }
  
  define inputSelectMultipleInternal(set : Ref<Set<Entity>>, from : List<Entity>, tname:String){
    var rnamehidden := tname + "_isinput"
    var reqhidden := getRequestParameter(rnamehidden)
    var req : List<String> := getRequestParameterList(tname)
       
    <input type="hidden" name=tname+"_isinput" />
    <select 
      multiple="multiple"
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      class="select "+attribute("class") 
      all attributes except "class"
    >
      for(e:Entity in from){
        <option 
          value=e.id
          if(reqhidden!=null && req!=null && e.id.toString() in req || reqhidden==null && set != null && e in set){ 
            selected="selected"
          }
        >
          output(e.name)
        </option>  
      }
    </select>
  
    databind{
      if(reqhidden != null){
        if(req == null || req.length == 0){
          set.clear();
        }
        else{
          var setlist : List<Entity> := set.list();
          var listofcurrentids : List<String> := [ e.id.toString() | e:Entity in setlist ];
          for(s:String in listofcurrentids){
            if(!(s in req) ){
              set.remove([ e | e:Entity in setlist where e.id.toString()==s ][0]);
            }
          }
          for(s:String in req){
            if(!(s in listofcurrentids)){
              set.add([ e | e:Entity in from where e.id.toString()==s ][0]); // check with 'from' list to make sure that it was an option, to protect against tampering
            }
          }
        }
      }
    }
  }
  
  //label
  
  define labelcolumns(s:String){
    label(s)[all attributes]{
      elements()
    }
    //define labelInternal(s:String, tname :String, tc :TemplateContext) = labelcolumnsInternal
    define labelInternal(s:String, tname :String, tc :TemplateContext){ 
      <td>
      <label for=tname all attributes>output(s)</label>
      </td>
      databind{ getPage().enterLabelContext(tname); }
      validate{ getPage().enterLabelContext(tname); }
      render{   getPage().enterLabelContext(tname); }
      <td>
      elements()
      </td>
      databind{ getPage().leaveLabelContext();}
      validate{ getPage().leaveLabelContext();}
      render{   getPage().leaveLabelContext();}
    }
  }
  
  define label(s:String) {
    var tname := getTemplate().getUniqueId()
    request var errors : List<String> := null
    request var tc := getPage().getTemplateContext().clone()
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        labelInternal(s,tname,tc)[all attributes]{
          elements()[templateContext=tc] //change templateContext to make sure the same name attributes are generated
        }
      }
    }
    else{
        labelInternal(s,tname,tc)[all attributes]{
          elements()[templateContext=tc]
        }
    }
    validate{
      errors := getPage().getValidationErrorsByName(tname);
    }
  }

  define labelInternal(s:String, tname :String, tc :TemplateContext){ 
    <label for=tname all attributes>output(s)</label>
    
    databind{ getPage().enterLabelContext(tname); }
    validate{ getPage().enterLabelContext(tname); }
    render{   getPage().enterLabelContext(tname); }
    
    elements()
    
    databind{ getPage().leaveLabelContext();}
    validate{ getPage().leaveLabelContext();}
    render{   getPage().leaveLabelContext();}
  }
  

  // input/output(Int)
  
  define output(i : Int){
    output(i.toString())
  }
  
  define input(i:Ref<Int>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputIntInternal(i,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputIntInternal(i,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      if(req != null){
        if(/-?\d+/.match(req)){
          if(req.parseInt() == null){
            errors := ["Outside of possible number range"];
          }
        }
        else{
          errors := ["Not a valid number"];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := i.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      }
      errors := handleValidationErrors(errors);     
    }
  }

  define inputIntInternal(i : Ref<Int>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      if(req != null){ 
        value = req 
      }
      else{
        value = i 
      }
      class="inputInt "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      if(req != null){
        i := req.parseInt();
      }
    }
  }

  //input/output Float
  
  define ignore-access-control output(i : Float){
    output(i.toString())
  }

  define input(i:Ref<Float>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null){
      errorTemplateInput(errors){
        inputFloatInternal(i,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputFloatInternal(i,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      if(req != null){
        if(/-?\d\d*\.\d*E?\d*/.match(req) || /-?\d\d*E?\d*/.match(req) || /-?\.\d\d*E?\d*/.match(req)){
          var f: Float := req.parseFloat(); 
          if(f == null){
            errors := ["Not a valid decimal number"];
          }
        }
        else{
          errors := ["Not a valid decimal number"];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := i.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      }
      errors := handleValidationErrors(errors);      
    }
  }

  define ignore-access-control inputFloatInternal(i : Ref<Float>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      if(req != null){ 
        value = req 
      }
      else{
        value = i 
      }
      class="inputFloat "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      if(req != null){
        i := req.parseFloat();
      }
    }
  }
  
  //input/output Long
  
  define output(i : Long){
    text(i.toString())
  }

  define input(i:Ref<Long>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null){
      errorTemplateInput(errors){
        inputLongInternal(i,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputLongInternal(i,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      if(req != null){
        if(/-?\d+/.match(req)){
          if(req.parseLong() == null){
            errors := ["Outside of possible number range"];
          }
        }
        else{
          errors := ["Not a valid number"];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := i.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      }
      errors := handleValidationErrors(errors);    
    }
  }
  
  define inputLongInternal(i : Ref<Long>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      if(req != null){ 
        value = req 
      }
      else{
        value = i 
      }
      class="inputLong "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      if(req != null){
        i := req.parseLong();
      }
    }
  }
  
  //input/output Secret
  
  define output(s: Secret){
    "********"
  }

  define input(s:Ref<Secret>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputSecretInternal(s,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputSecretInternal(s,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);  
    }
  }

  define inputSecretInternal(s : Ref<Secret>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      type="password"
      if(req != null){ 
        value = req 
      }
      else{
        value = s
      }
      class="inputSecret "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      if(req != null){
        s := req;
      }
    }
  }
  
  //input/output String
  
  define output(s: String){
    text(s)
  }

  define input(s:Ref<String>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputStringInternal(s,tname)[all attributes]
        validate{ getPage().enterLabelContext(tname); } 
        elements() 
        validate{ getPage().leaveLabelContext();}
      }
    }
    else{
      inputStringInternal(s,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);     
    }
  }

  define inputStringInternal(s : Ref<String>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      type="text"
      if(req != null){ 
        value = req 
      }
      else{
        value = s
      }
      class="inputString "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      if(req != null){
        s := req;
      }
    }
  }

  //input/output Text
  
  define output(s: Text){
    text(s)
  }

  define input(s:Ref<Text>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputTextInternal(s,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputTextInternal(s,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);    
    }
  }

  define inputTextInternal(s : Ref<Text>, tname : String){
    var req := getRequestParameter(tname)
    <textarea 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      class="inputTextarea inputText "+attribute("class") 
      all attributes except "class"
    >
      if(req != null){ 
        text(req) 
      }
      else{
        text(s)
      }  
    </textarea>
  
    databind{
      if(req != null){
        s := req;
      }
    }
  }


  //input/output URL
  
  define output(s: URL){
    navigate url(s) [all attributes] { url(s) }
  }

  define input(s:Ref<URL>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputURLInternal(s,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputURLInternal(s,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);    
    }
  }
  
  define inputURLInternal(s : Ref<URL>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      type="text"
      if(req != null){ 
        value = req 
      }
      else{
        value = s
      }
      class="inputURL "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      if(req != null){
        s := req;
      }
    }
  }

  //input/output WikiText
  
  
  define output(s: WikiText){
    rawoutput(s.format())
  }

  define input(s:Ref<WikiText>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputWikiTextInternal(s,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputWikiTextInternal(s,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);     
    }
  }

  define inputWikiTextInternal(s : Ref<WikiText>, tname : String){
    var req := getRequestParameter(tname)
    <textarea 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      class="inputTextarea inputWikiText "+attribute("class") 
      all attributes except "class"
    >
      if(req != null){ 
        text(req) 
      }
      else{
        text(s)
      }  
    </textarea>
  
    databind{
      if(req != null){
        s := req;
      }
    }
  }

  //input/output Email
  
  
  define output(s: Email){
    text(s)
  }

  define input(s:Ref<Email>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputEmailInternal(s,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputEmailInternal(s,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      if(req != null){
        if(!(req as Email).isValid()){
          errors := ["Not a valid email address"];
        }
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := s.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      }
      errors := handleValidationErrors(errors);     
    }
  }
  
  define inputEmailInternal(s : Ref<Email>, tname : String){
    var req := getRequestParameter(tname)
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      type="text"
      if(req != null){ 
        value = req 
      }
      else{
        value = s
      }
      class="inputEmail "+attribute("class") 
      all attributes except "class"
    />
    databind{
      if(req != null){
        s := req;
      }
    }
  }
  
  //input/output Bool
  
  
  define output(b : Bool){
    <input 
      type="checkbox"
      if(b){
       checked="true"
      }
      disabled="true" 
      all attributes 
    />
  }

  define input(b:Ref<Bool>){
    var tname := getTemplate().getUniqueId() // regular var is reset when validation fails
    request var errors : List<String> := null // need a var that keeps its value, even when validation fails
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputBoolInternal(b,tname)[all attributes]  // use same tname so the inputs are updated in both cases
        validate{ getPage().enterLabelContext(tname); } 
        elements() 
        validate{ getPage().leaveLabelContext();}
      }
    }
    else{
      inputBoolInternal(b,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := b.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);
    }
  }

  define inputBoolInternal(b : Ref<Bool>,rname:String){
    var rnamehidden := rname + "_isinput"
       
    <input type="hidden" name=rname+"_isinput" />
      <input type="checkbox" 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=rname 
      //true when it was submitted as true or it was not submitted but the value was already true
      if(getRequestParameter(rnamehidden)!=null && getRequestParameter(rname)!=null || getRequestParameter(rnamehidden)==null && b){ 
        checked="true"  
      }
      class="inputBool "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      var tmp : String := getRequestParameter(rname);
      var tmphidden := getRequestParameter(rnamehidden);
      if(tmphidden != null){
        if(getRequestParameter(rname) != null){
          b := true;     	
        }
        else{
          b := false;
        }
      }
    }
  }
  
  //input File
  
  define input(f:Ref<File>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    if(errors != null){
      errorTemplateInput(errors){
        inputFileInternal(f,tname)[all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputFileInternal(f,tname)[all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      errors := f.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      errors := handleValidationErrors(errors);  
    }
  }

  
  define inputFileInternal(f : Ref<File>, tname : String){
    init{
      getPage().formRequiresMultipartEnc := true;
    }
    <input 
      if(getPage().inLabelContext()) { 
        id=getPage().getLabelString() 
      } 
      name=tname 
      type="file"
      class="inputFile "+attribute("class") 
      all attributes except "class"
    />
  
    databind{
      var fnew : File := getPage().getFileUpload(tname);
      if(fnew != null && fnew.fileName() != ""){
        f := fnew;
      }
    }
  }
  
  
  //input Image
  
    
  define input(i : Ref<Image>){
    input(i as Ref<File>)[all attributes]
  }

  //validate entities
  
  entity ValidationException {
    message :: String
  }
  entity ValidationExceptionMultiple{
    exceptions -> List<ValidationException>
  }

  //validate template
  
  define validate(check:Bool,message:String){
    request var errors : List<String> := null
    if(errors != null){
      errorTemplateForm(errors)[all attributes]
    }
    validate{
      if(!check){ 
        errors := [message];
      }
      errors := handleValidationErrors(errors);
    }
  }
  
  // Stratego ATerm SDF
  
  native class org.webdsl.tools.strategoxt.SDF as SDF{
    static get(String):SDF
    isValid(String):Bool
    getSGLRError(String):String
    parse(String):ATerm
  }      
 
  define inputSDF(s:Ref<Text>,language: String){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)

    request var errors : List<String> := null
    
    if(errors != null && errors.length > 0){
      errorTemplateInput(errors){
        inputTextInternal(s,tname)[class="inputSDF", all attributes]
      }
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    else{
      inputTextInternal(s,tname)[class="inputSDF", all attributes]
      validate{ getPage().enterLabelContext(tname); } 
      elements() 
      validate{ getPage().leaveLabelContext();}
    }
    validate{
      if(req != null && !SDF.get(language).isValid(req)){
        errors := [SDF.get(language).getSGLRError(req)];
      }
      if(errors == null){ // if no wellformedness errors, check datamodel validations
        errors := s.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname)); //nested validate elements
      }
      errors := handleValidationErrors(errors);     
    }
  }
  
  type String{
    org.webdsl.tools.strategoxt.ATerm.toATerm as parseATerm():ATerm
  }

  native class org.spoofax.interpreter.terms.IStrategoTerm as ATerm{
    org.webdsl.tools.strategoxt.ATerm.subterms as subterms():List<ATerm>
    org.webdsl.tools.strategoxt.ATerm.constructor as constructor():String
    org.webdsl.tools.strategoxt.ATerm.stringValue as stringValue():String
    org.webdsl.tools.strategoxt.ATerm.get as get(Int):ATerm
    org.webdsl.tools.strategoxt.ATerm.length as length():Int
    org.webdsl.tools.strategoxt.ATerm.toString as toString():String
    org.webdsl.tools.strategoxt.ATerm.toInt as toInt():Int
  }
  
  define output(a:ATerm){
    output(a.toString())
  }
  
  native class org.webdsl.tools.strategoxt.StrategoProgram as Stratego{
    static get(String):Stratego
    invoke(String,ATerm):ATerm
    invoke(String,String):ATerm
  }
  
  
  // inputs with ajax validation
  // @TODO address issues with template arguments to reduce code duplication 
  
  define ajax showMessages(list:List<String>){
    errorTemplateInput(list)
  }
  
  define ajax noMessages(){}  
  
  define inputajax(b:Ref<Bool>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputBoolInternal(b,tname)[onchange=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := b.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := b.getValidationErrors();
      getPage().enterLabelContext(tname); 
      validatetemplate(elements());
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
  
  function checkFloatWellformedness(req:String):List<String>{
    var errors :List<String>:= null; 
    if(req != null){
      if(/-?\d\d*\.\d*E?\d*/.match(req) || /-?\d\d*E?\d*/.match(req) || /-?\.\d\d*E?\d*/.match(req)){
        var f: Float := req.parseFloat(); 
        if(f == null){
          errors := ["Not a valid decimal number"];
        }
      }
      else{
        errors := ["Not a valid decimal number"];
      }
    }
    return errors;
  }
  define inputajax(f:Ref<Float>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputFloatInternal(f,tname)[onkeyup=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := checkFloatWellformedness(req);
      if(errors==null){
        errors := f.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := checkFloatWellformedness(req);
      if(errors==null){
        errors := f.getValidationErrors();
        getPage().enterLabelContext(tname); 
        validatetemplate(elements()); 
        getPage().leaveLabelContext();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
  
  function checkIntWellformedness(req:String):List<String>{
    var errors :List<String>:= null; 
    if(req != null){
      if(/-?\d+/.match(req)){
        if(req.parseInt() == null){
          errors := ["Outside of possible number range"];
        }
      }
      else{
        errors := ["Not a valid number"];
      }
    }
    return errors;
  }
  define inputajax(i:Ref<Int>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputIntInternal(i,tname)[onkeyup=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := checkIntWellformedness(req);
      if(errors==null){
        errors := i.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := checkIntWellformedness(req);
      if(errors==null){
        errors := i.getValidationErrors();
        getPage().enterLabelContext(tname); 
        validatetemplate(elements()); 
        getPage().leaveLabelContext();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
  
  function checkLongWellformedness(req:String):List<String>{
    var errors :List<String>:= null; 
    if(req != null){
      if(/-?\d+/.match(req)){
        if(req.parseLong() == null){
          errors := ["Outside of possible number range"];
        }
      }
      else{
        errors := ["Not a valid number"];
      }
    }
    return errors;
  }
  define inputajax(l:Ref<Long>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputLongInternal(l,tname)[onkeyup=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := checkLongWellformedness(req);
      if(errors==null){
        errors := l.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := checkLongWellformedness(req);
      if(errors==null){
        errors := l.getValidationErrors();
        getPage().enterLabelContext(tname); 
        validatetemplate(elements()); 
        getPage().leaveLabelContext();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }

  define inputajax(s:Ref<Secret>){
    inputajax(s as Ref<String>)[all attributes] 	
  }
  define inputajax(s:Ref<URL>){
    inputajax(s as Ref<String>)[all attributes] 	
  }
  define inputajax(s:Ref<Text>){
    inputajax(s as Ref<String>)[all attributes] 	
  }
  define inputajax(s:Ref<WikiText>){
    inputajax(s as Ref<String>)[all attributes] 	
  }
  define inputajax(s:Ref<String>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputStringInternal(s,tname)[onkeyup=validator(), all attributes]
    //handle validations passed in call to this template
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := s.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := s.getValidationErrors();
      //ignore-validation prevents regular validation, manually execute validate phase for elements
      getPage().enterLabelContext(tname); 
      validatetemplate(elements()); 
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }  
  function checkEmailWellformedness(req:String):List<String>{
    var errors :List<String>:= null; 
      if(req != null){
        if(!(req as Email).isValid()){
          errors := ["Not a valid email address"];
        }
      }
    return errors;
  }
  define inputajax(s:Ref<Email>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputEmailInternal(s,tname)[onkeyup=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := checkEmailWellformedness(req);
      if(errors==null){
        errors := s.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := checkEmailWellformedness(req);
      if(errors==null){
        errors := s.getValidationErrors();
        getPage().enterLabelContext(tname); 
        validatetemplate(elements());
        getPage().leaveLabelContext();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
 
  define inputajax(set:Ref<Set<Entity>>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputCheckboxSetInternal(set,from,tname)[onclick=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := set.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := set.getValidationErrors();
      //ignore-validation prevents regular validation, manually execute validate phase for elements
      getPage().enterLabelContext(tname); 
      validatetemplate(elements()); 
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }  

  define selectajax(ent : Ref<Entity>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputEntityInternal(ent,from,tname)[onchange=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := ent.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := ent.getValidationErrors();
      getPage().enterLabelContext(tname); 
      validatetemplate(elements());
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
  
  define selectajax(set:Ref<Set<Entity>>, from : List<Entity>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputSelectMultipleInternal(set,from,tname)[onchange=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := set.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := set.getValidationErrors();
      getPage().enterLabelContext(tname); 
      validatetemplate(elements());
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
    
  define radioajax(ent1 : Ref<Entity>, ent2 : List<Entity>){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    radioInternal(ent1,ent2,tname)[onchange=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := ent1.getValidationErrors();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := ent1.getValidationErrors();
      getPage().enterLabelContext(tname); 
      validatetemplate(elements());
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName(tname));
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
  
  function checkSDFWellformedness(req:String,language:String):List<String>{
    var errors :List<String>:= null; 
    if(req != null && !SDF.get(language).isValid(req)){
      errors := [SDF.get(language).getSGLRError(req)];
    }
    return errors;
  }
  define inputSDFajax(s:Ref<Text>,language: String){
    var tname := getTemplate().getUniqueId()
    var req := getRequestParameter(tname)
    request var errors : List<String> := null
    inputTextInternal(s,tname)[class="inputSDF", onkeyup=validator(), all attributes]
    validate{ getPage().enterLabelContext(tname); } 
    elements() 
    validate{ getPage().leaveLabelContext();}
    placeholder "validate"+tname {
      if(errors != null && errors.length > 0){
        showMessages(errors)
      }
    }
    validate{
      errors := checkSDFWellformedness(req,language);
      if(errors==null){
        errors := s.getValidationErrors();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        cancel();
      }
    }
    action ignore-validation validator(){
      errors := checkSDFWellformedness(req,language);
      if(errors==null){
        errors := s.getValidationErrors();
        getPage().enterLabelContext(tname); 
        validatetemplate(elements()); 
        getPage().leaveLabelContext();
        errors.addAll(getPage().getValidationErrorsByName(tname));
      }
      if(errors.length > 0){
        replace("validate"+tname,showMessages(errors));
      }
      else{
        replace("validate"+tname,noMessages());
      } 	
      rollback();
    }
  }
  
  //validation message templates
  
  define errorTemplateInput(messages : List<String>){
    block(){
      elements()
      for(ve: String in messages){
        block()[style := "color: #FF0000"]{
          text(ve)
        }     
      }
    }
  } 

  define errorTemplateForm(messages : List<String>){
    block(){
      for(ve: String in messages){
        block()[style := "color: #FF0000;"]{
          text(ve)
        }     
      }
    }
  }

  define errorTemplateAction(messages : List<String>){
    block(){
      for(ve: String in messages){
        block()[style := "color: #FF0000;"]{
          text(ve)
        }     
      }
      elements()
    }
  }
    
  define templateSuccess(messages : List<String>){
    block(){
      for(ve: String in messages){
        block()[style := "color: #BB8800;"]{
          text(ve)   
        }    
      }
    }
  }
    
  define messages(){
    request var list : List<String> := List<String>()
    render{
      list.addAll(getPage().getIncomingSuccessMessages());
      getPage().clearIncomingSuccessMessages();
    }
    if(list.length > 0){
      templateSuccess(list)
    }
  }
      
  //page not found page    
     
  define page pagenotfound(){
    <h3>"404 Not Found"</h3>
  }     
      
  //access denied page
     
  define page accessDenied(){
    title{"Access Denied"}
    text("Access Denied: ")
    navigate(root()) { "return to home page" }
  }
    
  //default access control rule
  
  access control rules
    rule page accessDenied(){true}
    rule page pagenotfound(){true}
    rule template *(*){true}

    