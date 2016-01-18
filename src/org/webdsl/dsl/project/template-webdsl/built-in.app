module .servletapp/src-webdsl-template/built-in

// overridable attributes for generator built-in templates and library input templates

attributes navigate{ class = "navigate" }
attributes downloadlink{ class = "downloadlink" }
attributes outputimage{ class = "outputimage" }
attributes submit{ class = "button" }
attributes submitlink{ }
attributes form{ }
attributes navigatebutton{ }
attributes captcha{ }
attributes image{ }

attributes inputInt{ class = "inputInt" }
attributes inputBool{ class = "inputBool" }
attributes inputString{ class = "inputString" }
attributes inputEmail{ class = "inputEmail" }
attributes inputSecret{ class = "inputSecret" }
attributes inputURL{ class = "inputURL" }
attributes inputText{ class = "inputTextarea inputText" }
attributes inputWikiText{ class = "inputTextarea inputWikiText" }
attributes inputFloat{ class = "inputFloat" }
attributes inputLong{ class = "inputLong" }
attributes inputDate{ class = "inputDate" }
attributes inputSetCheckbox{ class = "checkbox-set" }
attributes inputSetCheckboxElements{ class = "checkbox-set-element" }
attributes inputSelect{ class = "select" }
attributes inputSelectMultiple{ class = "select" }
attributes inputFile{ class = "inputFile" }
attributes inputMultiFile{ class = "inputFile" }
attributes inputSDF{ class = "inputSDF" }
attributes radio{ class = "radio" }

// page request statistics

native class utils.Statistics as RequestStatistics{
  static logStatistics()
}

function logStatistics(){
  RequestStatistics.logStatistics();
}

invoke logStatistics() every 5 minutes

// hibbernate transaction management

native class utils.IncludePaths as IncludePaths{
  static jQueryJS(): String
  static jQueryUIJS(): String
  static jQueryUICSS(): String
  static timepickerJS(): String
  static timepickerCSS(): String
}

native class utils.ValidationException as NativeValidationException{
  getName(): String
  getErrorMessage(): String
  isRelevantObject( Object ): Bool
}

native class utils.HibernateTransactionHelper as HibernateTransactionHelper{
  static commitAndStartNewTransaction(): [NativeValidationException]
  static rollbackAndStartNewTransaction()
}

function commitAndStartNewTransaction(): [NativeValidationException]{
  return HibernateTransactionHelper.commitAndStartNewTransaction();
}

function rollbackAndStartNewTransaction(){
  HibernateTransactionHelper.rollbackAndStartNewTransaction();
}

// session management

invoke internalCleanupSessionManagerEntities() every 10 minutes

function internalUpdateSessionManagerTimeout() : Bool{
  var n: DateTime := now().addMinutes( -30 ); // update lastUse after 30 minutes to avoid unnecessary db writes, also sets minimum timeout to 30 minutes
  var man := getSessionManager();
  if(   man.lastUse == null
     || man.lastUse.before( n )
  ){
    man.lastUse := now();
    return true;
  }
  return false;
}

function internalCleanupSessionManagerEntities(){
  var sessiontimeout := 6; //months
  var n: DateTime := now().addMonths( -1 * sessiontimeout );
  var ses := from SessionManager as sc where sc.lastUse is null or sc.lastUse < ~n limit 25; //use limit to avoid loading all obsolete entities in one transaction
  for( s: SessionManager in ses ){
    s.delete();
  }
}

// search

//optimization of search index, twice a day
invoke optimizeSearchIndex() every 12 hours

//Update the spell check and autocompletion indices twice a day
invoke updateSuggestionIndex() every 12 hours

//renew facet index readers every 15 minutes
invoke renewFacetIndexReaders() every 15 minutes

function renewFacetIndexReaders(){
  IndexManager.renewFacetIndexReaders();
}

function optimizeSearchIndex(){
  IndexManager.optimizeIndex();
}

function updateSuggestionIndex(){
  IndexManager.indexSuggestions();
}

native class webdsl.generated.search.IndexManager as IndexManager{
  static indexSuggestions()
  static indexSuggestions( [String] )
  static optimizeIndex()
  static renewFacetIndexReaders()
  static clearAutoCompleteIndex( String )
  static clearSpellCheckIndex( String )
  static reindex( Entity )
  static reindex( List<Entity> )
  static removeFromIndex( Entity )
  static reindex()
}

native class org.webdsl.search.SearchHelper as SearchHelper{
   static firstIndexLink( Int, Int, Int ): Int
   static lastIndexLink( Int, Int, Int ): Int
}

native class org.webdsl.search.DynamicSearchField as DynamicSearchField{
   constructor( String, String )
}

native class org.webdsl.search.WebDSLFacet as Facet{
  constructor()
  static fromString( String ): Facet
  asString(): String
  isSelected(): Bool
  getCount(): Int
  getValue(): String
  getFieldName(): String
  getValueAsDate(): Date
  getValueAsFloat(): Float
  getValueAsInt(): Int
  must(): Facet
  mustNot(): Facet
  should(): Facet
  isMust(): Bool
  isMustNot(): Bool
  isShould(): Bool
}

function escapeQuery( q: String ): String{
  return Searcher.escapeQuery( q );
}

native class org.webdsl.search.AbstractEntitySearcher as Searcher{
  static escapeQuery( String ): String
  static fromString( String ): Searcher
  asString(): String
  enableFaceting( String, Int ): Searcher
  enableFaceting( String, String ): Searcher
  getFacets( String ): [Facet]
  addFacetSelection( Facet ): Searcher
  addFacetSelection( [Facet] ): Searcher
  getFacetSelection(): [Facet]
  getFacetSelection( String ): [Facet]
  removeFacetSelection( Facet ): Searcher
  clearFacetSelection(): Searcher
  clearFacetSelection( String ): Searcher
  highlight( String, String ):  String
  highlight( String, String, String, String, Int, Int, String ): String
  highlight( String, String, String, String ): String
  highlightLargeText( String, String ):  String
  highlightLargeText( String, String, String, String, Int, Int, String ): String
  highlightLargeText( String, String, String, String ): String
  highlightHTML( String, String ):  String
  highlightHTML( String, String, String, String, Int, Int, String ): String
  highlightHTML( String, String, String, String ): String
  highlightLargeHTML( String, String ):  String
  highlightLargeHTML( String, String, String, String, Int, Int, String ): String
  highlightLargeHTML( String, String, String, String ): String
  getQuery(): String
  luceneQuery(): String
  searchTime(): String
  searchTimeMillis(): Int
  searchTimeSeconds(): Float
  allowLuceneSyntax( Bool ): Searcher
  addFieldFilter( String, Object ): Searcher
  addFieldFilter( String, String ): Searcher
  getFilteredFields(): [String]
  getFieldFilterValue( String ): String
  removeFieldFilter( String ): Searcher
  clearFieldFilters(): Searcher
  startMustClause(): Searcher
  startMustNotClause(): Searcher
  startShouldClause(): Searcher
  results(): [Entity]
  must(): Searcher
  should(): Searcher
  not(): Searcher
  endClause(): Searcher
  setNamespace( String ): Searcher
  setNamespace( Object ): Searcher
  getNamespace(): String
  removeNamespace(): Searcher
  boost( String, Float ): Searcher
  strictMatching( Bool ): Searcher
  field( String ): Searcher
  fields( [String] ): Searcher
  defaultFields(): Searcher
  getFields(): [String]
  setOffset( Int ): Searcher
  getOffset(): Int
  setLimit( Int ): Searcher
  getLimit(): Int
  scores(): [Float]
  explanations(): [String]
  count(): Int
  moreLikeThis( String ): Searcher
  sortDesc( String ): Searcher
  sortAsc( String ): Searcher
  clearSorting(): Searcher
  reset(): Searcher
  query( Object ): Searcher
  query( String ): Searcher
  phraseQuery( String, Int ): Searcher
  phraseQuery( Object, Int ): Searcher
  regexQuery( String ): Searcher
  rangeQuery( Int, Int, Bool, Bool ): Searcher
  rangeQuery( Float, Float, Bool, Bool ): Searcher
  rangeQuery( Date, Date, Bool, Bool ): Searcher
  rangeQuery( String, String, Bool, Bool ): Searcher
  rangeQuery( Int, Int ): Searcher
  rangeQuery( Float, Float ): Searcher
  rangeQuery( Date, Date ): Searcher
  rangeQuery( String, String ): Searcher
  matchAllQuery(): Searcher
}

native class org.webdsl.search.SearchStatistics as SearchStatistics{
  static clear(): Void
  static getSearchQueryExecutionCount(): Long
  static getSearchQueryTotalTime(): Long
  static getSearchQueryExecutionMaxTime(): Long
  static getSearchQueryExecutionAvgTime(): Long
  static getSearchQueryExecutionMaxTimeQueryString(): String
  static getObjectLoadingTotalTime(): Long
  static getObjectLoadingExecutionMaxTime(): Long
  static getObjectLoadingExecutionAvgTime(): Long
  static getObjectsLoadedCount(): Long
  static isStatisticsEnabled(): Bool
  static setStatisticsEnabled( Bool ): Bool
  static getSearchVersion(): String
  static getIndexedClassNames(): [String]
  static indexedEntitiesCount(): [String]
}

//The default analyzer, equal to the one used by default in hibernate search
default_builtin_analyzer analyzer hsearchstandardanalyzer{
  tokenizer = StandardTokenizer
  token filter = StandardFilter
  token filter = LowerCaseFilter
  token filter = StopFilter
}

//Template showing the info available through Hibernate Search statistics
template showSearchStats(){
  var NStoMS: Long := 1000000L;
  table{
    row{ column{ <b> "Search statistics" </b> } }
    row{ column{ "Statistics enabled?" } column { output( SearchStatistics.isStatisticsEnabled() ) if( !SearchStatistics.isStatisticsEnabled() ){ "(Enabled through searchstats=true in application.ini)" } } }
    row{ column{ "Hibernate Search version" } column { output( SearchStatistics.getSearchVersion() ) } }

    row{ column{ <b> "Query execution times" </b> } }

    row{ column{ "Search query execution count" } column { output( SearchStatistics.getSearchQueryExecutionCount() ) } }
    row{ column{ "Total search time" } column { output( SearchStatistics.getSearchQueryTotalTime() / NStoMS ) "ms  (" output( SearchStatistics.getSearchQueryTotalTime() ) "ns)" } }
    row{ column{ "Average search query exec time" } column { output( SearchStatistics.getSearchQueryExecutionAvgTime() / NStoMS ) "ms  (" output( SearchStatistics.getSearchQueryExecutionAvgTime() ) "ns)" } }
    row{ column{ "Slowest search query exec time" } column { output( SearchStatistics.getSearchQueryExecutionMaxTime() / NStoMS ) "ms  (" output( SearchStatistics.getSearchQueryExecutionMaxTime() ) "ns)" } }
    row{ column{ "Slowest search query" } column { output( SearchStatistics.getSearchQueryExecutionMaxTimeQueryString() ) } }

    row{ column{ <b> "Object load times" </b> } }

    row{ column{ "Objects loaded count" } column { output( SearchStatistics.getObjectsLoadedCount() ) } }
    row{ column{ "Total object loading time" } column { output(SearchStatistics.getObjectLoadingTotalTime()/ NStoMS ) "ms  (" output( SearchStatistics.getObjectLoadingTotalTime() ) "ns)" } }
    row{ column{ "Average object loading time" } column { output(SearchStatistics.getObjectLoadingExecutionAvgTime() / NStoMS ) "ms  (" output( SearchStatistics.getObjectLoadingExecutionAvgTime() ) "ns)" } }
    row{ column{ "Slowest object loading time" } column { output(SearchStatistics.getObjectLoadingExecutionMaxTime() / NStoMS ) "ms  (" output( SearchStatistics.getObjectLoadingExecutionMaxTime() ) "ns)" } }
  }
  table{
    row{ column{ <b> "Indexed entities (entity - nOfEntities)" </b> } }
    row{ column{ output( SearchStatistics.indexedEntitiesCount() ) } }
  }
}

//Tries to highlight the elements inside, not touching the html tags inside (highlighter invoked to ignore html tags)
//If nothing is highlighted, it just renders elements
//Hits are surrounded by tags <span class = "highlightcontent">HIT</span>
template highlight( s: Searcher, fld: String ){
  var rendered   := rendertemplate( elements );
  var renderedHL := if( s != null ) s.highlightLargeHTML( fld, rendered, "<span class=\"highlightcontent\">", "</span>", 1, 10000000, "" )
                    else "";
  if( renderedHL != null && renderedHL.length() > 0 ){
    rawoutput( renderedHL )[ all attributes ]
  }
  else{
    rawoutput( rendered )[ all attributes ] //don't render twice
  }
}

//Outputs a summary surrogate for the given text 'txt' based on constraints in searcher 's' for search field 'fld'
//A summary suggorate will consist of at most 3 fragments of max 80 characters seperated by '... '
//Hits are surrounded by tags <span class = "highlightcontent">HIT</span>
template highlightedSummary( s: Searcher, fld: String, txt: String ){
  var decorated := highlightHTML ~fld: txt from s with tags ("HLOPENTAG", "HLCLOSETAG");
  var prerendered := rendertemplate( output("... " + decorated + " ...") )
  var tagsfixed := prerendered.replace( "HLOPENTAG", "<span class=\"highlightcontent\">" )
                              .replace( "HLCLOSETAG", "</span>" );
  rawoutput( tagsfixed )[ all attributes ]
}

//Outputs a summary surrogate for the given text 'txt' based on constraints in searcher 's' for search field 'fld'
//A summary suggorate will consist of at most 3 fragments of max 80 characters seperated by '... '
//Hits are surrounded by tags <span class = "highlightcontent">HIT</span>
template highlightedSummary( s: Searcher, fld: String, txt: WikiText ){
  var decorated := highlightHTML ~fld: txt from s with tags ("HLOPENTAG", "HLCLOSETAG");
  var prerendered := rendertemplate( output( ( ("... " + decorated + " ...") as WikiText)  ) )
  //also remove links from summaries
  var tagsfixed := prerendered.replace( "<a ", "<span " )
                              .replace( "</a ", "</span " )
                              .replace( "HLOPENTAG", "<span class=\"highlightcontent\">" )
                              .replace( "HLCLOSETAG", "</span>" )
  rawoutput( tagsfixed )[ all attributes ]
}


// section methods for built-in types

type String{ //includes other String-based types such as Secret, Patch, Email, URL, etc.
  length(): Int
  toLowerCase(): String
  toUpperCase(): String
  replace( String, String ): String
  startsWith( String ): Bool
  startsWith( String, Int ): Bool
  endsWith( String ): Bool
  trim(): String
  utils.StringType.parseUUID                   as parseUUID(): UUID
  org.webdsl.tools.Utils.containsDigit         as containsDigit(): Bool
  org.webdsl.tools.Utils.containsLowerCase     as containsLowerCase(): Bool
  org.webdsl.tools.Utils.containsUpperCase     as containsUpperCase(): Bool
  org.webdsl.tools.Utils.isCleanUrl            as isCleanUrl(): Bool
  org.apache.commons.lang3.StringUtils.contains as contains( String ): Bool // this 'contains' function handles null, null as either arg will produce false
  utils.StringType.parseInt                    as parseInt(): Int
  utils.StringType.split                       as split(): [String]
  utils.StringType.splitWithSeparator          as split( String ): [String] //TODO Regex as argument
  utils.StringType.parseLong                   as parseLong(): Long
  utils.StringType.parseFloat                  as parseFloat(): Float
  utils.DateType.parseDate as parseDate( String ): Date
  utils.DateType.parseDate as parseDateTime( String ): DateTime
  utils.DateType.parseDate as parseTime( String ): Time
  org.apache.commons.lang3.StringEscapeUtils.escapeEcmaScript as escapeJavaScript(): String
  substring( Int ): String
  substring( Int, Int ): String
  utils.StringType.similarity as similarity(String) : Float 
}

type Secret{
  org.webdsl.tools.Utils.secretDigest  as digest(): Secret
  org.webdsl.tools.Utils.secretCheck   as check(Secret): Bool
}

type Patch{
  name.fraser.neil.plaintext.patch_factory.patchApply  as applyPatch( String ): String
  name.fraser.neil.plaintext.patch_factory.unpatchApply  as revertPatch( String ): String
  name.fraser.neil.plaintext.patch_factory.diffHTML  as diffHTML( Bool ): String
}
type String{
  name.fraser.neil.plaintext.patch_factory.patchMake   as makePatch( String ): Patch
  name.fraser.neil.plaintext.patch_factory.diff        as diff( String ): [String]
}

type Long{
  intValue(): Int
}

type DateTime{ // includes Date and Time types
  utils.DateType.format as format( String ): String
  before( DateTime ): Bool
  after( DateTime ): Bool
  getTime(): Long
  setTime( Long )
  utils.DateType.addYears as addYears( Int ): DateTime
  utils.DateType.addMonths as addMonths( Int ): DateTime
  utils.DateType.addDays as addDays( Int ): DateTime
  utils.DateType.addHours as addHours( Int ): DateTime
  utils.DateType.addMinutes as addMinutes( Int ): DateTime
  utils.DateType.addSeconds as addSeconds( Int ): DateTime
  utils.DateType.getYear as getYear(): Int
  utils.DateType.getMonth as getMonth(): Int
  utils.DateType.getDay as getDay(): Int
  utils.DateType.getDayOfYear as getDayOfYear(): Int
  utils.DateType.getHour as getHour(): Int
  utils.DateType.getMinute as getMinute(): Int
  utils.DateType.getSecond as getSecond(): Int
}

function age( d: Date ): Int{
  var today: Date := today();
  var age := today.getYear() - d.getYear();
  if( today.getDayOfYear() < d.getDayOfYear() ){
    age := age - 1;
  }
  return age;
}

native class utils.DateType as DateType{ //@TODO static functions not yet supported in type import of DateTime above
  static getDefaultDateFormat(): String
  static getDefaultTimeFormat(): String
  static getDefaultDateTimeFormat(): String
}

type WikiText{
  org.webdsl.tools.WikiFormatter.wikiFormat as format(): String
  org.webdsl.tools.WikiFormatter.wikiFormatNoTagFiltering as formatNoTagFiltering(): String
}

type Email{
  utils.EmailType.isValid as isValid(): Bool
}

type URL{
  utils.URLType.isValid as isValid(): Bool
  utils.URLType.download as download(): File
}

type File{
  getContentAsString(): String
  getContentType(): String
  setContentType( String )
  getFileName(): String
  delete() : File
}
type String{
  utils.File.createFromString as asFile( String ): File
}
type Image{
  getContentAsString(): String
  getContentType(): String
  setContentType( String )
  getFileName(): String
  delete() : File
}

// access to servlet context

native class AbstractDispatchServletHelper as DispatchServlet{
  getIncomingSuccessMessages(): [String]
  getOutgoingSuccessMessages(): [String]
  clearSuccessMessages()
  getRequest(): HttpServletRequest
  static get(): DispatchServlet
  getBaseUrl(): String
  getUrlComponents(): [String]
}
function getDispatchServlet(): DispatchServlet{
  return DispatchServlet.get();
}

native class javax.servlet.http.HttpServletRequest as HttpServletRequest{
  getRemoteAddr(): String
}

function remoteAddress(): String{
  return getDispatchServlet().getRequest().getRemoteAddr();
}
function baseUrl(): String{
  return getDispatchServlet().getBaseUrl();
}
function urlComponents(): [String]{
  return getDispatchServlet().getUrlComponents();
}

// access to page context

native class AbstractPageServlet as PageServlet{
  inSubmittedForm(): Bool
  formRequiresMultipartEnc: Bool
  getFileUploads( String ): [File]
  getLabelString(): String
  inLabelContext(): Bool
  addValidationException( String, String )
  getValidationErrorsByName( String ): [String]
  static getRequestedPage(): PageServlet
  enterLabelContext( String )
  leaveLabelContext()
  setTemplateContext( TemplateContext )
  getTemplateContext(): TemplateContext
  setMimetype( String )
  isRedirected(): Bool
  getRedirectUrl(): String
  setRedirectUrl( String )
  enableDownloadInline()
  addReRenderPlaceholders( String )
  addBodyAttribute( String, String )
  submitWrapOpenHelper( String )
  submitWrapCloseHelper()
  actionHasAjaxPageUpdates: Bool
}
function getPage(): PageServlet{
  return PageServlet.getRequestedPage();
}
function replace( ph: String ){
  getPage().addReRenderPlaceholders( ph );
  getPage().actionHasAjaxPageUpdates := true;
}

native class utils.TemplateContext as TemplateContext{
  clone(): TemplateContext
  getTemplateContextString(): String
}

function mimetype( s: String ){
  getPage().setMimetype( s );
}
template mimetype( s: String ){
  init{
    getPage().setMimetype( s );
  }
}

function downloadInline(){
  getPage().enableDownloadInline();
}
template downloadInline(){
  init{
    downloadInline();
  }
}

function addBodyAttribute( key: String, value: String ){
  getPage().addBodyAttribute( key, value );
}
template addBodyAttribute( key: String, value: String ){
  init{
    addBodyAttribute( key, value );
  }
}

//access to template context

native class TemplateServlet as TemplateServlet{
  getUniqueId(): String
  getUniqueIdNoCache(): String
  static getCurrentTemplate(): TemplateServlet
}
function getTemplate(): TemplateServlet{
  return TemplateServlet.getCurrentTemplate();
}

// utitity for templates that handle validation

function handleValidationErrors( errors: [String] ): [String]{
  var result: [String] := null;
  if( errors != null && errors.length > 0 ){
    if( getPage().inLabelContext() ){
      for( s: String in errors ){
        getPage().addValidationException( getPage().getLabelString(), s );
      }
    }
    else{
      result := errors;
    }
    cancel();
  }
  return result;
}

// section XML
native class org.w3c.dom.Document as XMLDocument{
	org.webdsl.xml.XMLUtil.getElementsByTagName as getElementsByTagName(String) : List<XMLNode>
	org.webdsl.xml.XMLUtil.getElementsByXPath as getElementsByXPath(String) : List<XMLNode>
}

native class org.w3c.dom.Node as XMLNode{
	org.webdsl.xml.XMLUtil.getElementsByTagName as getElementsByTagName(String) : List<XMLNode>
	org.webdsl.xml.XMLUtil.getElementsByXPath as getElementsByXPath(String) : List<XMLNode>
	javaxt.xml.DOM.getNodeValue as getVal() : String
	org.webdsl.xml.XMLUtil.getText as getVal(String) : String
	javaxt.xml.DOM.getAttributeValue as getAttrVal(String) : String
	
}

type String{
	javaxt.xml.DOM.createDocument as asXMLDocument() : XMLDocument
}

//  section JSON for services

native class org.json.JSONObject as JSONObject{
  constructor()
  constructor( String )
  NULL: Object
  get( String ): Object
  getBoolean( String ): Bool
  getDouble( String ): Double
  getInt( String ): Int
  getLong( String ): Long
  getJSONArray( String ): JSONArray
  getJSONObject( String ): JSONObject
  getString( String ): String
  has( String ): Bool
  names(): JSONArray
  put( String, Object )
  toString(): String
  toString( Int ): String
}

native class org.json.JSONArray as JSONArray{
  constructor()
  constructor( String )
  get( Int ): Object
  getBoolean( Int ): Bool
  getDouble( Int ): Double
  getInt( Int ): Int
  getJSONArray( Int ): JSONArray
  getJSONObject( Int ): JSONObject
  getString( Int ): String
  length(): Int
  join( String ): String
  put( Object )
  remove( Int )
  toString(): String
  toString( Int ): String
}

native class java.lang.Double as Double{
    constructor( Double )
    constructor( String )
    floatValue(): Float
}

//  section WebDriver for testing

function sleep( i: Int ){
  UtilsTestClass.sleep(i);
}
function createTempFile( s: String ): String{
  return UtilsTestClass.createTempFile(s);
}

function getFirefoxDriver(): FirefoxDriver{
  return UtilsTestClass.getFirefoxDriver();
}
function getHtmlUnitDriver(): HtmlUnitDriver{
  return UtilsTestClass.getHtmlUnitDriver();
}
function getDriver(): WebDriver{
  return getFirefoxDriver();
}

native class utils.Test as UtilsTestClass{
  static sleep( Int )
  static getHtmlUnitDriver(): HtmlUnitDriver
  static getFirefoxDriver(): FirefoxDriver
  static closeDrivers()
  static createTempFile( String ): String
}


native class org.openqa.selenium.WebDriver as WebDriver{
  get( String )
  getTitle(): String
  getPageSource(): String
  findElement( SelectBy ): WebElement
  findElements( SelectBy ): [WebElement]
  close()
  utils.Test.runJavaScript as runJavaScript( String ): String
  utils.Test.getAlert as getAlert(): WebAlert
  utils.Test.getSubmit as getSubmit(): WebElement
  utils.Test.getSubmits as getSubmits(): [WebElement]
}

native class org.openqa.selenium.Alert as WebAlert{
  getText(): String
  dismiss()
  accept()
}

native class org.openqa.selenium.By as SelectBy{
  static className( String ): SelectBy
  static id( String ): SelectBy
  static linkText( String ): SelectBy
  static name( String ): SelectBy
  static partialLinkText( String ): SelectBy
  static tagName( String ): SelectBy
  static cssSelector( String ): SelectBy
  static xpath( String ): SelectBy
}

native class org.openqa.selenium.WebElement as WebElement{
  getText(): String
  utils.Test.getValue as getValue(): String //WebElement.getValue() is deprecated
  getElementName(): String
  getAttribute( String ): String
  isEnabled(): Bool
  sendKeys( String )
  submit()
  clear()
  getAttribute( String ): String
  isEnabled(): Bool
  isSelected(): Bool
  findElements( SelectBy ): [WebElement]
  //void sendKeys(java.lang.CharSequence... keysToSend)
  utils.Test.click as toggle()
  utils.Test.click as setSelected()
  utils.Test.clickAndWait as click()
}

native class org.openqa.selenium.htmlunit.HtmlUnitDriver as HtmlUnitDriver: WebDriver{
  constructor()
}

native class org.openqa.selenium.firefox.FirefoxDriver as FirefoxDriver: WebDriver{
  constructor()
  utils.Test.takeScreenshot as takeScreenshot()
}

native class org.openqa.selenium.support.ui.Select as Select{
  deselectAll() // Clear all selected entries.
  deselectByIndex( Int ) // Deselect the option at the given index.
  deselectByValue( String ) // Deselect all options that have a value matching the argument.
  deselectByVisibleText( String ) // Deselect all options that display text matching the argument.
  escapeQuotes( String ): String
  getAllSelectedOptions(): [WebElement]
  getFirstSelectedOption(): WebElement
  getOptions(): [WebElement]
  isMultiple(): Bool
  selectByIndex( Int ) // Select the option at the given index.
  selectByValue( String ) // Select all options that have a value matching the argument.
  selectByVisibleText( String ) // Select all options that display text matching the argument.
  constructor( WebElement )
}

//email

entity QueuedEmail{
  body: String (length=1000000) //Note: default length for string is currently 255
  to: String (length=1000000)
  cc: String (length=1000000)
  bcc: String (length=1000000)
  replyTo: String (length=1000000)
  from: String (length=1000000)
  subject: String (length=1000000)
  unsubscribeAddress: String (length=1000000)
  // scheduled: DateTime (default=now())
  lastTry: DateTime
}

invoke internalHandleEmailQueue() every 15 seconds

function internalHandleEmailQueue(){
  var n: DateTime := now().addHours( -3 ); // retry after 3 hours to avoid spamming too much
  var dontRetryMoment: DateTime := now().addDays( -3 ); //dont retry emails older than 3 days
  var queuedEmails := from QueuedEmail as q where (q.lastTry is null or q.lastTry < ~n) and q.created > ~dontRetryMoment order by q.created asc limit 5;
  for( queuedEmail: QueuedEmail in queuedEmails ){
    if( sendemail( sendQueuedEmail( queuedEmail ) ) ){
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

native class utils.ThreadLocalEmailContext as ThreadLocalEmailContext{
  static inEmailContext(): Bool
}

function inEmailContext(): Bool {
  return ThreadLocalEmailContext.inEmailContext();
}
define email sendQueuedEmail( q: QueuedEmail ){
  to( q.to )
  from( q.from )
  subject( q.subject )
  cc( q.cc )
  bcc( q.bcc )
  replyTo( q.replyTo )
  unsubscribeAddress( q.unsubscribeAddress )
  //don't escape the html from internal email rendering
  rawoutput( q.body )
}


// logging

entity RequestLogEntry{
  name: String
  requestedURL: Text
  start: DateTime
  end: DateTime
  clientIP: String
  clientPort: Int
  method: String
  referer: Text
  userAgent: Text
}

//built-in templates

// convenient for desugaring in the compiler that replaces template elements with a single templatecall, see RenderTemplateFunctionCall desugaring
template internalElementsWrapper(){ elements }

// e.g. head{ <meta charset="utf-8"/> }
template head(){ includeHead( rendertemplate( elements ) ) }

htmlwrapper{
  h1 h1
  h2 h2
  h3 h3
  h4 h4
  h5 h5
  h6 h6
  div div
  span span
  table table
  row tr
  column td
  par p
  pre pre
  spacer hr
  list ul[ class = "block" ]
  listitem li[ class = "block" ]
  block div[ class = "block" ]
  container span[ class = "container" ]
  groupitem tr
  strong strong
  emph em
  code code
}

template br(){ <br all attributes> }

template break(){ <br all attributes> }

template block( s: String ){
  <div class = "block" class = s all attributes>
    elements
  </div>
}

template fieldset( s: String ){
  <fieldset all attributes>
    <legend>
      output( s )
    </legend>
    elements
  </fieldset>
}

template group( s: String ){
  <fieldset all attributes>
    <legend>
      output( s )
    </legend>
    <table>
      elements
    </table>
  </fieldset>
}

template group(){
  <fieldset class = "fieldset_no_legend_" all attributes>
    <table>
      elements
    </table>
  </fieldset>
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

template menubar(){
  var elementid := "menu" + id
  includeCSS( "dropdownmenu.css" )
  <div class = "menuwrapper"
       id = elementid
       all attributes>
    <ul id = "p7menubar"
        class = "menubar">
      elements
    </ul>
  </div>
}

template menuspacer(){
  <li all attributes>
    elements
  </li>
}

template menu(){
  <li class = "menu" all attributes>
    elements
  </li>
}

template menuheader(){
  <span class = "menuheader" all attributes>
    elements
  </span>
}

template menuitems(){
  <ul class = "menuitems">
    elements
  </ul>
}

template menuitem(){
  <li class = "menuitem" all attributes>
    elements
  </li>
}

//reflection of entities

native class org.webdsl.lang.ReflectionEntity as ReflectionEntity{
  getName(): String
  getProperties(): [ReflectionProperty]
  getPropertyByName( String ): ReflectionProperty
  hasViewPage(): Bool
  static byName( String ): ReflectionEntity
  static all(): [ReflectionEntity]
}

native class org.webdsl.lang.ReflectionProperty as ReflectionProperty{
  getName(): String
  hasNotNullAnnotation(): Bool
  getFormatAnnotation(): String
}

//validation wrapper for submit and submitlink

template wrapsubmit( tname: String ) requires s( String ){
  render{ getPage().submitWrapOpenHelper( tname ); }
  if( getValidationErrorsByName( tname ).length > 0 ){
    errorTemplateAction( getValidationErrorsByName( tname ) ){
      s( tname )
    }
  }
  else{
    s( tname )
  }
  render{ getPage().submitWrapCloseHelper(); }
}

//reused when elements are empty

template elementsempty(){}

// Date/DateTime/Time input and output templates

template output( d: ref DateTime ){
  var default := DateType.getDefaultDateTimeFormat();
  if( d != null ){
    dateoutputgeneric( d as ref Date, default )[ all attributes ]
  }
}

template output(d: ref Time){
  var default := DateType.getDefaultTimeFormat();
  if( d != null ){
    dateoutputgeneric( d as ref Date, default )[ all attributes ]
  }
}

template output( d: ref Date ){
  var default := DateType.getDefaultDateFormat();
  if( d != null ){
    dateoutputgeneric( d, default )[ all attributes ]
  }
}

template dateoutputgeneric( d: ref Date, defaultformat: String ){
  var dateformat := defaultformat;
  init{
    //@TODO add support for ref arg in function, to avoid repeating this in both output and input
    var attr := attribute( "format" );
    if(    attr != null
        && attr != ""
    ){
      dateformat := attr;
    }
    else{
      if( d.getReflectionProperty() != null ){
        var formatanno := d.getReflectionProperty().getFormatAnnotation();
        if( formatanno != null ){
          dateformat := formatanno;
        }
      }
    }
  }
  output( d.format( dateformat ) )
}

template input( d: ref DateTime ){
  input( d, now().addYears( -30 ), now().addYears( 50 ) )[ all attributes ]{ elements }
}
template input( d: ref Date, minDate: DateTime, maxDate: DateTime ){
  var format := DateType.getDefaultDateFormat()
  var dateformatString := ""
  var minDateOpt := "minDate: new Date(" + minDate.getYear() + ", " + minDate.getMonth() + ", " + minDate.getDay() + ", " + minDate.format("HH") + ", " + minDate.getMinute() + ")"
  var maxDateOpt := "maxDate: new Date(" + maxDate.getYear() + ", " + maxDate.getMonth() + ", " + maxDate.getDay() + ", " + minDate.format("HH") + ", " + maxDate.getMinute() + ")"
  init{
    var attr := attribute( "format" );
    if(    attr != null
        && attr != ""
    ){
      format := attr;
    }
    else{
      if( d.getReflectionProperty() != null ){
        var formatanno := d.getReflectionProperty().getFormatAnnotation();
        if( formatanno != null ){
          format := formatanno;
        }
      }
    }
    dateformatString := "dateFormat: '" + convertDateFormatToJQuery( format ) + "', ";
  }
  dateinputgeneric(
    d
  , format
  , "datepicker"
  , dateformatString + " changeMonth: true, changeYear: true, " + minDateOpt + ", " + maxDateOpt
  )[ all attributes ]{ elements }
}
template input( d: ref DateTime, minDate: DateTime, maxDate: DateTime ){
  var format := DateType.getDefaultDateTimeFormat()
  var minDateOpt := "minDate: new Date(" + minDate.getYear() + ", " + minDate.getMonth() + ", " + minDate.getDay() + ", " + minDate.format("HH") + ", " + minDate.getMinute() + ")"
  var maxDateOpt := "maxDate: new Date(" + maxDate.getYear() + ", " + maxDate.getMonth() + ", " + maxDate.getDay() + ", " + maxDate.format("HH") + ", " + maxDate.getMinute() + ")"
  var dateformatString := ""
  var timeformatString := ""
  init{
    var attr := attribute( "format" );
    if(    attr != null
        && attr != ""
    ){
      format := attr;
    }
    else{
      if( d.getReflectionProperty() != null ){
        var formatanno := d.getReflectionProperty().getFormatAnnotation();
        if( formatanno != null ){
          format := formatanno;
        }
      }
    }
    var tmp := /\s(?=(h|H))+/.split( format );
    // var tmp := format.split( " " ); //assumes date and time are separated by space and no other spaces in the format string
    dateformatString := "dateFormat: '" + convertDateFormatToJQuery( tmp[ 0 ] ) + "', ";
    timeformatString := "timeFormat: '" + tmp[ 1 ] + "', ";
  }
  dateinputgeneric(
    d as ref Date
  , format
  , "datetimepicker"
  , dateformatString + timeformatString + " changeMonth: true, changeYear: true, " + minDateOpt + ", " + maxDateOpt
  )[ all attributes ]{ elements }
}

template input( d: ref Time ){
  var format := DateType.getDefaultTimeFormat()
  var timeformatString := ""
  init{
    var attr := attribute("format");
    if(    attr != null
        && attr != ""
    ){
      format := attr;
    }
    else{
      if( d.getReflectionProperty() != null ){
        var formatanno := d.getReflectionProperty().getFormatAnnotation();
        if( formatanno != null ){
          format := formatanno;
        }
      }
    }
    timeformatString := "timeFormat: '" + format + "'";
  }
  dateinputgeneric( d as ref Date, format, "timepicker", timeformatString )[ all attributes ]{ elements }
}
/*
function convertTimeFormatToJQuery( f: String ): String{
  return f.replace( "H", "h" );
}
*/
function convertDateFormatToJQuery( f: String ): String{
  return f.replace( "MMM", "M" ).replace( "EEE", "D" ).replace( "yy", "y" ).replace( "MM", "mm" );
}

template input( d: ref Date ){
  input( d, now().addYears( -50 ), now().addYears( 10 ) )[ all attributes ]{elements}
}
template input( d: ref Date, minYear: Int, maxYear: Int ){
  var format := DateType.getDefaultDateFormat()
  var dateformatString := ""
  init{
    var attr := attribute( "format" );
    if(    attr != null 
        && attr != ""
    ){
      format := attr;
    }
    else{
      if( d.getReflectionProperty() != null ){
        var formatanno := d.getReflectionProperty().getFormatAnnotation();
        if( formatanno != null ){
          format := formatanno;
        }
      }
    }
    dateformatString := "dateFormat: '" + convertDateFormatToJQuery( format ) + "', ";
  }
  dateinputgeneric(
    d
  , format
  , "datepicker"
  , dateformatString + " changeMonth: true, changeYear: true, yearRange: '" + minYear + ":"+maxYear + "'"
  )[ all attributes ]{ elements }
}

template dateinputgeneric( d: ref Date, dateformat: String, picker: String, options: String ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      datepickerinput( d, dateformat, id, picker, options )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    datepickerinput( d, dateformat, id, picker, options )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    if( req != null ){
      if(    req != ""
          && req.parseDate( dateformat ) == null
      ){
        errors := [ "Incorrect date format, expected format is " + dateformat ];
      }
    }
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := d.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

template datepickerinput( d: ref Date, dateformat: String, tname: String, picker: String, options: String ){
  var s: String
  init{
    if( d == null ){
      s := "";
    }
    else{
      s := d.format( dateformat );
    }
  }

  includeJS( IncludePaths.jQueryJS() )
  includeJS( IncludePaths.jQueryUIJS() )
  includeJS( IncludePaths.timepickerJS() )
  includeCSS( IncludePaths.jQueryUICSS() )
  includeCSS( IncludePaths.timepickerCSS() )

  var req := getRequestParameter( tname )

  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    type = "text"
    if( req != null ){
      value = req
    }
    else{
      value = s
    }
    inputDate attributes
    all attributes
  />

  //uses setTimeout which seems to give better results when used in combination with webdsl ajax
  <script>
    setTimeout("$('input[name=~tname]').~picker({~options})", 500);
  </script>

  databind{
    if( req != null ){
      if( req == "" ){
        d := null;
      }
      else{
        var newdate := req.parseDateTime( dateformat );
        if( newdate != null ){
          d := newdate;
        }
      }
    }
  }
}

//output( Set )
/*
template output( set: {Entity} ){
  <ul all attributes>
    for( e: Entity in set order by e.name ){
      <li>
        output( e )
      </li>
    }
  </ul>
}
*/

//input( {Entity} )

template input( set: ref {Entity} ){
  selectcheckbox( set, set.getAllowed() )[ all attributes ]{ elements }
}
template input( set: ref {Entity}, from: [Entity] ){
  selectcheckbox( set, from )[ all attributes ]{ elements }
}

//input( {Entity} ) selectcheckbox

template selectcheckbox( set: ref {Entity} ){
  selectcheckbox( set, set.getAllowed() )[ all attributes ]{ elements }
}
template selectcheckbox( set: ref {Entity}, from: [Entity] ){
  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputCheckboxSetInternal( set, from, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputCheckboxSetInternal( set, from, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := set.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputCheckboxSetInternal( set: ref {Entity}, from: [Entity], tname: String ){
  var tnamehidden := tname + "_isinput"
  var reqhidden := getRequestParameter( tnamehidden )
  request var tmpset := Set<Entity>()

  <div inputSetCheckbox attributes
       all attributes except "onclick">
    <input type="hidden" name = tnamehidden/>
    for( e: Entity in from ){
      inputCheckboxSetInternalHelper( set, tmpset, e, tname + "-" + e.id )[ onclick = "" + attribute( "onclick" ) ]
    }
  </div>
  databind{
    if( reqhidden != null && tmpset != set ){
      set := tmpset;
    }
  }
}

template inputCheckboxSetInternalHelper( set: ref {Entity}, tmpset: {Entity}, e: Entity, tname: String ){
  var tmp := getRequestParameter( tname )
  var tnamehidden := tname + "_isinput"
  var tmphidden := getRequestParameter( tnamehidden )
  <div inputSetCheckboxElements attributes >
    <input type = "hidden" name = tnamehidden/>
    <input type = "checkbox"
      name = tname
      if(       tmphidden != null
             && tmp != null
          ||
                tmphidden == null
             && e in set
      ){
        checked = "true"
      }
      id = tname + e.id
      all attributes
    />
    <label for = tname + e.id>
      outputLabel( e )
    </label>
  </div>
  databind{
    if(    tmphidden != null
        && tmp != null
    ){
      tmpset.add( e );
    }
  }
}

//input( {Entity} ) select

template select( set: ref {Entity} ){
  select( set, set.getAllowed() )[ all attributes ]{ elements }
}
template select( set: ref {Entity}, from: [Entity] ){
  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputSelectMultipleInternal( set, from, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputSelectMultipleInternal( set, from, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := set.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputSelectMultipleInternal( set: ref {Entity}, from: [Entity], tname: String ){
  var rnamehidden := tname + "_isinput"
  var reqhidden := getRequestParameter( rnamehidden )
  var req: [String] := getRequestParameterList( tname )

  <input type = "hidden"
         name = tname + "_isinput"/>
  <select
    multiple = "multiple"
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    inputSelectMultiple attributes
    all attributes
  >
    for( e: Entity in from ){
      <option
        value = e.id
        if(       reqhidden != null
               && req != null
               && e.id.toString() in req
            ||
                  reqhidden == null
               && set != null
               && e in set
        ){
          selected = "selected"
        }
      >
        outputLabel( e )
      </option>
    }
  </select>

  databind{
    if( reqhidden != null ){
      if(    req == null
          ||
                req.length == 0
             && set.length != 0
      ){
        set.clear();
      }
      else{
        var setlist: [Entity] := set.list();
        var listofcurrentids: [String] := [ e.id.toString() | e: Entity in setlist ];
        for( s: String in listofcurrentids ){
          if( ! (s in req) ){
            set.remove( [ e | e: Entity in setlist where e.id.toString() == s ][ 0 ] );
          }
        }
        for( s: String in req ){
          if( ! (s in listofcurrentids) ){
            set.add( [ e | e: Entity in from where e.id.toString() == s ][ 0 ] ); // check with 'from' list to make sure that it was an option, to protect against tampering
          }
        }
      }
    }
  }
}


// input(e: Entity)

template input( ent: ref Entity ){
  select( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template input( ent: ref Entity, from: [Entity] ){
  select( ent, from )[ all attributes ]{ elements }
}

//input(e:Entity) select

template select( ent: ref Entity ){
  select( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template select( ent: ref Entity, from: [Entity] ){
  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputEntityInternal( ent, from, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputEntityInternal( ent, from, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := ent.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputEntityInternal( ent: ref Entity, from: [Entity], tname: String ){
  var rnamehidden := tname + "_isinput"
  var reqhidden := getRequestParameter( rnamehidden )
  var req: String := getRequestParameter( tname )
  var notnull :=    hasNotNullAttribute()
                 || 
                       ent.getReflectionProperty() != null
                    && ent.getReflectionProperty().hasNotNullAnnotation()
  <input type = "hidden"
         name = tname + "_isinput" />
  <select
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    inputSelect attributes
    all attributes
  >
    if( ! notnull ){
      <option value = "none"
        if(       reqhidden != null
               && req == null
            ||
                  reqhidden == null
               && ent == null
        ){
          selected = "selected"
        }
      ></option>
    }
    for( e: Entity in from ){
      <option
        value = e.id
        if(       reqhidden != null
               && req != null
               && e.id.toString() == req
            ||
                  reqhidden == null
               && e == ent
        ){
          selected = "selected"
        }
      >
        outputLabel( e )
      </option>
    }
  </select>

  databind{
    if( reqhidden != null ){
      if(    ! notnull
          && req == "none"
      ){
        ent := null;
      }
      else{
        var fromids := [ e | e: Entity in from where e.id.toString() == req ];
        if(    fromids.length > 0
            && ent != fromids[ 0 ]
        ){
          ent := fromids[ 0 ]; // check with 'from' list to make sure that it was an option, to protect against tampering
        }
      }
    }
  }
}

// radio buttons input

template radio( ent: ref Entity ){
  radio( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template radio( ent1: ref Entity, ent2: [Entity] ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      radioInternal( ent1, ent2, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    radioInternal( ent1, ent2, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := ent1.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template radioInternal( ent1: ref Entity, ent2: [Entity], tname: String ){
  var tmp: String := getRequestParameter( tname );
  var subme: Entity := null;
  init{
    if( tmp != null ){
      var matching := [ e | e: Entity in ent2 where e.id.toString() == tmp ];
      if(    matching.length > 0
          && ent1 != matching[ 0 ]
      ){
        subme := matching[ 0 ];
      }
    }
  }
  for( e: Entity in ent2 ){
    <label radio attributes>
      <input type = "radio"
        //either it was submitted or it was not submitted but the value was already p
        if(       tmp != null
               && subme == e
            ||
                  tmp == null
               && ent1 == e
        ){
          checked = "checked"
        }
        name = tname
        value = e.id
        all attributes
      />
      outputLabel( e )
    </label>
  }
  databind{
    if(    tmp != null
        && subme in ent2
        && ent1 != subme
    ){
      ent1 := subme;
    }
  }
}



//output(Entity)

template outputLabel( e: Entity ){
  output( e.name )
}

/*
template output( e: Entity ){
  var hasviewpage := false;
  var viewpagename := "";
  init{
    var type := e.getTypeString();
    hasviewpage := ReflectionEntity.byName( type ).hasViewPage();
    viewpagename := type.toLowerCase();
  }
  if( hasviewpage ){
    //not possible yet
    navigate ~viewpagename((~type) e){ outputLabel(e) }
  }
  else{
    outputLabel( e )
  }
}*/


//output(List)

/*
template output( list: [Entity] ){
  <ol all attributes>
    for( e:Entity in list ){
      <li>
        output( e )
      </li>
    }
  </ol>
}
*/

// input(List)

template input( list: ref [Entity] ){
  input( list, list.getAllowed() )[ all attributes ]{ elements }
}
template input( list: ref [Entity], from: [Entity] ){
  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputListInternal( list, from, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputListInternal( list, from, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := list.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

function updateListRequest( request: String, list: [Entity], selectfrom: [Entity] ): [Entity]{
  if( request == null ){ // nothing submitted
    return list;
  }
  var elementids := request.split( "," );
  var options := List<Entity>();
  options.addAll( list );
  options.addAll( selectfrom );
  var newlist := List<Entity>();
  for( s: String in elementids ){
    var ent := [ e | e: Entity in options where e.id.toString() == s ];
    if( ent.length > 0 ){
      var selected := ent[ 0 ];
      newlist.add( selected );
    }
  }
  return newlist;
}

template inputListInternal( list: ref [Entity], selectfrom: [Entity], tname: String ){
  var hiddenid := "hidden" + tname
  var sortableid := "sortable" + tname
  var selectid := "select" + tname
  var tmp := getRequestParameter( hiddenid );
  var newlist := updateListRequest( tmp, list, selectfrom );
  var onchange := attribute( "onchange" );
  var deletejsfuncname := "delete" + tname;
  databind{
    if( tmp != null && list != newlist ){
      list := newlist;
    }
  }

  includeCSS( IncludePaths.jQueryUICSS() )
  includeJS( IncludePaths.jQueryJS() )
  includeJS( IncludePaths.jQueryUIJS() )

  <script type="text/javascript">
    $(function(){
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
    window.~deletejsfuncname = function(dollarthis){
      dollarthis.parent().remove();
      $('#~hiddenid').attr('value', $('#~sortableid').sortable('toArray'));
      ~onchange
    };
  </script>
  <input type = "hidden"
         name = hiddenid
         id = hiddenid/>
  <ul id = sortableid
      class = "sortable">
    for( e: Entity in newlist ){
      <li id = e.id
          class = "ui-state-default">
        <span class = "ui-icon ui-icon-arrowthick-2-n-s"></span>
        outputLabel( e )
        <span class = "ui-icon ui-icon-close" onclick=deletejsfuncname+"($(this));"></span>
      </li>
    }
  </ul>

  //@TODO should become possible to re-use render of template in client
  var p1 := "<li id=\""
  var p2 := "\" class=\"ui-state-default\"><span class=\"ui-icon ui-icon-arrowthick-2-n-s\"></span>"
  var p3 := "<span class=\"ui-icon ui-icon-close\" onclick=\""+deletejsfuncname+"($(this));\"></span></li>"

  if( selectfrom.length > 0 ){
    <select id = selectid>
    for( e: Entity in selectfrom ){
      <option value = e.id>
        outputLabel( e )
      </option>
    }
    </select>

    <input type="button"
           value="add"
           onclick="$('select#"+selectid+" option:selected').each(function(){ $('#"+sortableid+"').append('"+p1+"'+$(this).attr('value')+'"+p2+"'+$(this).html()+'"+p3+"');}); $('#"+hiddenid+"').attr('value', $('#"+sortableid+"').sortable('toArray')); "+onchange+"return false;" />
  }
}


//label

template labelcolumns( s: String ){
  label( s )[ all attributes ]{ elements }
  //template labelInternal( s: String, tname: String, tc: TemplateContext ) = labelcolumnsInternal
  template labelInternal( s1: String, tname: String, tc: TemplateContext ){
    <td>
    <label for=tname all attributes>
      output(s1)
    </label>
    </td>
    databind{ getPage().enterLabelContext( tname ); }
    validate{ getPage().enterLabelContext( tname ); }
    render{   getPage().enterLabelContext( tname ); }
    <td>
    elements
    </td>
    databind{ getPage().leaveLabelContext();}
    validate{ getPage().leaveLabelContext(); }
    render{   getPage().leaveLabelContext();}
  }
}

template label( s: String ) {
  request var errors: [String] := null
  request var tc := getPage().getTemplateContext().clone()

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      labelInternal( s, id, tc )[ all attributes ]{
        elements[ templateContext = tc ] //change templateContext to make sure the same name attributes are generated
      }
    }
  }
  else{
      labelInternal( s, id, tc )[ all attributes ]{
        elements[templateContext = tc]
      }
  }
  validate{
    errors := getPage().getValidationErrorsByName( id );
  }
}

template labelInternal( s: String, tname: String, tc: TemplateContext ){
  <label for = tname all attributes>
    output( s )
  </label>

  databind{ getPage().enterLabelContext( tname ); }
  validate{ getPage().enterLabelContext( tname ); }
  render{   getPage().enterLabelContext( tname ); }

  elements

  databind{ getPage().leaveLabelContext();}
  validate{ getPage().leaveLabelContext(); }
  render{   getPage().leaveLabelContext();}
}


// input/output( Int )

template output( i: Int ){
  output( i.toString() )
}

template input( i: ref Int ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputIntInternal( i, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputIntInternal( i, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    if( req != null ){
      if( /-?\d+/.match( req ) ){
        if( req.parseInt() == null ){
          errors := [ "Outside of possible number range" ];
        }
      }
      else{
        errors := [ "Not a valid number" ];
      }
    }
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := i.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

template inputIntInternal( i: ref Int, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    if( req != null ){
      value = req
    }
    else{
      value = i
    }
    inputInt attributes
    all attributes
  />

  databind{
    if( req != null ){
      i := req.parseInt();
    }
  }
}

//input/output Float

template output( i: Float ){
  output( i.toString() )
}

template input( i: ref Float ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null ){
    errorTemplateInput( errors ){
      inputFloatInternal( i, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputFloatInternal( i, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    if( req != null ){
      if(   /-?\d\d*\.\d*E?\d*/.match( req )
         || /-?\d\d*E?\d*/.match( req )
         || /-?\.\d\d*E?\d*/.match( req )
      ){
        var f: Float := req.parseFloat();
        if( f == null ){
          errors := [ "Not a valid decimal number" ];
        }
      }
      else{
        errors := [ "Not a valid decimal number" ];
      }
    }
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := i.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

template inputFloatInternal( i: ref Float, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    if( req != null ){
      value = req
    }
    else{
      value = i
    }
    inputFloat attributes
    all attributes
  />

  databind{
    if( req != null ){
      i := req.parseFloat();
    }
  }
}

//input/output Long

template output( i: Long ){
  text( i.toString() )
}

template input( i: ref Long ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null ){
    errorTemplateInput( errors ){
      inputLongInternal( i, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputLongInternal( i, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    if( req != null ){
      if( /-?\d+/.match( req ) ){
        if( req.parseLong() == null ){
          errors := [ "Outside of possible number range" ];
        }
      }
      else{
        errors := [ "Not a valid number" ];
      }
    }
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := i.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

template inputLongInternal( i: ref Long, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    if( req != null ){
      value = req
    }
    else{
      value = i
    }
    inputLong attributes
    all attributes
  />

  databind{
    if( req != null ){
      i := req.parseLong();
    }
  }
}

//input/output Secret

template output( s: Secret ){
  "********"
}

template input( s: ref Secret ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputSecretInternal( s, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputSecretInternal( s, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputSecretInternal( s: ref Secret, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    type = "password"
    if( req != null ){
      value = req
    }
    else{
      value = s
    }
    inputSecret attributes
    all attributes
  />

  databind{
    if( req != null ){
      s := req;
    }
  }
}

//output Placeholder

template output( p: Placeholder ){
  text( p.toString() )
}

//input/output String

template output( s: String ){
  text( s )
}

template input( s: ref String ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputStringInternal( s, id )[ all attributes ]
      validate{ getPage().enterLabelContext( id ); }
      elements
      validate{ getPage().leaveLabelContext(); }
    }
  }
  else{
    inputStringInternal( s, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputStringInternal( s: ref String, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    if( attribute( "type" ) == "" ){
      type = "text"
    }
    if( req != null ){
      value = req
    }
    else{
      value = s
    }
    inputString attributes
    all attributes
  />

  databind{
    if( req != null ){
      s := req;
    }
  }
}

template inputSearch( s: ref String ){
  input( s )[ type = "search", all attributes ]
}

//input/output Text

template output( s: Text ){
  text( s )
}

template input( s: ref Text ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputTextInternal( s, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputTextInternal( s, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputTextInternal( s: ref Text, tname: String ){
  var req := getRequestParameter( tname )
  <textarea
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    inputText attributes
    all attributes
  >
    if( req != null ){
      text(req)
    }
    else{
      text(s)
    }
  </textarea>

  databind{
    if( req != null ){
      s := req;
    }
  }
}


//input/output URL

template output( s: URL ){
  navigate url( s )[ all attributes ]{ url( s ) }
}

template input( s: ref URL ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputURLInternal( s, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputURLInternal( s, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  
  validate{
    errors := checkURLWellformedness(req);
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := s.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

template inputURLInternal( s: ref URL, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    type = "text"
    if( req != null ){
      value = req
    }
    else{
      value = s
    }
    inputURL attributes
    all attributes
  />

  databind{
    if( req != null ){
      s := req;
    }
  }
}

//input/output WikiText

template output( s: WikiText ){
  rawoutput( s.format() )
}

template rawoutput( t: WikiText ){
  rawoutput( t.formatNoTagFiltering() )
}

template input( s: ref WikiText ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputWikiTextInternal( s, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputWikiTextInternal( s, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := s.getValidationErrors(); //only length annotation and property validations are relevant here, these are provided by getValidationErrors
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputWikiTextInternal( s: ref WikiText, tname: String ){
  var req := getRequestParameter( tname )
  <textarea
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    inputWikiText attributes
    all attributes
  >
    if( req != null ){
      text( req )
    }
    else{
      text( s )
    }
  </textarea>

  databind{
    if( req != null ){
      s := req;
    }
  }
}

//input/output Email

template output( s: Email ){
  text( s )
}

template input( s: ref Email ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputEmailInternal( s, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputEmailInternal( s, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    if( req != null ){
      if( ! (req as Email).isValid() ){
        errors := [ "Not a valid email address" ];
      }
    }
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := s.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

template inputEmailInternal( s: ref Email, tname: String ){
  var req := getRequestParameter( tname )
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    type = "text"
    if( req != null ){
      value = req
    }
    else{
      value = s
    }
    inputEmail attributes
    all attributes
  />
  databind{
    if( req != null ){
      s := req;
    }
  }
}

//input/output Bool

template output( b: Bool ){
  <input
    type = "checkbox"
    if( b ){
     checked = "true"
    }
    disabled = "true"
    all attributes
  />
}

template input( b: ref Bool ){
  request var errors: [String] := null // request var keeps its value, even when validation fails (regular var is reset when validation fails)

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputBoolInternal( b, id )[ all attributes ]  // use same id so the inputs are updated in both cases
      validate{ getPage().enterLabelContext( id ); }
      elements
      validate{ getPage().leaveLabelContext(); }
    }
  }
  else{
    inputBoolInternal( b, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := b.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputBoolInternal( b: ref Bool, rname: String ){
  var rnamehidden := rname + "_isinput"

  <input type = "hidden" name=rname + "_isinput" />
    <input type = "checkbox"
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = rname
    //true when it was submitted as true or it was not submitted but the value was already true
    if(       getRequestParameter( rnamehidden ) != null
           && getRequestParameter( rname ) != null
        ||
              getRequestParameter( rnamehidden ) == null
           && b
    ){
      checked = "true"
    }
    inputBool attributes
    all attributes
  />

  databind{
    var tmp: String := getRequestParameter( rname );
    var tmphidden := getRequestParameter( rnamehidden );
    if( tmphidden != null ){
      if( getRequestParameter( rname ) != null ){
        b := true;
      }
      else{
        b := false;
      }
    }
  }
}

//input File

template input( f: ref File ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  if( errors != null ){
    errorTemplateInput( errors ){
      inputFileInternal( f, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputFileInternal( f, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := f.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}


template inputFileInternal( f: ref File, tname: String ){
  render{
    getPage().formRequiresMultipartEnc := true;
  }
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    type = "file"
    inputFile attributes
    all attributes
  />

  databind{
    var files: [File] := getPage().getFileUploads( tname );
    if( files != null && files.length > 0 ){
      var fnew := files.get( 0 );
      if( fnew.fileName() != "" ){
        f := fnew;
      }
    }
  }
}

template input( f: ref [File] ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  if( errors != null ){
    errorTemplateInput( errors ){
      inputMultiFileInternal( f, id )[ all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputMultiFileInternal( f, id )[ all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    errors := f.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    errors := handleValidationErrors( errors );
  }
}

template inputMultiFileInternal( f: ref [File], tname: String ){
  render{
    getPage().formRequiresMultipartEnc := true;
  }
  <input
    if( getPage().inLabelContext() ){
      id = getPage().getLabelString()
    }
    name = tname
    type = "file"
    inputMultiFile attributes
    all attributes
    multiple = ""
  />

  databind{
    var files: [File] := getPage().getFileUploads( tname );
    if( files != null && files.length > 0 ){
      for( item in files where item.fileName() != "" ){
        f.add( item );
      }
    }
  }
}


//input Image


template input( i: ref Image ){
  input( i as ref File )[ all attributes ]
}

//validate entities

entity ValidationException{
  message: String
}
entity ValidationExceptionMultiple{
  exceptions: [ValidationException]
}

//validate template

template validate( check: Bool, message: String ){
  request var errors: [String] := null
  if( errors != null ){
    errorTemplateForm( errors )[ all attributes ]
  }
  validate{
    if( ! check ){
      errors := [ message ];
    }
    errors := handleValidationErrors( errors );
  }
}

// Stratego ATerm SDF

native class org.webdsl.tools.strategoxt.SDF as SDF{
  static get( String ): SDF
  isValid( String ): Bool
  getSGLRError( String ): String
  parse( String ):ATerm
}

template inputSDF( s: ref Text, language: String ){
  var req := getRequestParameter( id )

  request var errors: [String] := null

  if( errors != null && errors.length > 0 ){
    errorTemplateInput( errors ){
      inputTextInternal( s, id )[ inputSDF attributes, all attributes ]
    }
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  else{
    inputTextInternal( s, id )[ inputSDF attributes, all attributes ]
    validate{ getPage().enterLabelContext( id ); }
    elements
    validate{ getPage().leaveLabelContext(); }
  }
  validate{
    if(    req != null 
        && ! SDF.get( language ).isValid( req )
    ){
      errors := [ SDF.get( language ).getSGLRError( req ) ];
    }
    if( errors == null ){ // if no wellformedness errors, check datamodel validations
      errors := s.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) ); //nested validate elements
    }
    errors := handleValidationErrors( errors );
  }
}

type String{
  org.webdsl.tools.strategoxt.ATerm.toATerm as parseATerm(): ATerm
}

native class org.spoofax.interpreter.terms.IStrategoTerm as ATerm{
  org.webdsl.tools.strategoxt.ATerm.subterms as subterms(): [ATerm]
  org.webdsl.tools.strategoxt.ATerm.constructor as constructor(): String
  org.webdsl.tools.strategoxt.ATerm.stringValue as stringValue(): String
  org.webdsl.tools.strategoxt.ATerm.get as get( Int ): ATerm
  org.webdsl.tools.strategoxt.ATerm.length as length(): Int
  org.webdsl.tools.strategoxt.ATerm.toString as toString(): String
  org.webdsl.tools.strategoxt.ATerm.toInt as toInt(): Int
}

template output( a: ATerm ){
  output( a.toString() )
}

native class org.webdsl.tools.strategoxt.StrategoProgram as Stratego{
  static get( String ): Stratego
  invoke( String, ATerm ): ATerm
  invoke( String, String ): ATerm
}


// inputs with ajax validation
// @TODO address issues with template arguments to reduce code duplication

ajax template showMessages( list: [String] ){
  errorTemplateInput( list )
}

ajax template noMessages(){}

template inputajax( b: ref Bool ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputBoolInternal( b, id )[ onchange = validator(); "" + attribute("onchange")
                            , all attributes except "onchange" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := b.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := b.getValidationErrors();
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

function checkFloatWellformedness( req: String ): [String]{
  var errors: [String] := null;
  if( req != null ){
    if(   /-?\d\d*\.\d*E?\d*/.match( req )
       || /-?\d\d*E?\d*/.match( req )
       || /-?\.\d\d*E?\d*/.match( req )
    ){
      var f: Float := req.parseFloat();
      if( f == null ){
        errors := [ "Not a valid decimal number" ];
      }
    }
    else{
      errors := [ "Not a valid decimal number" ];
    }
  }
  return errors;
}
template inputajax( f: ref Float ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputFloatInternal( f, id )[ oninput = validator(); "" + attribute("oninput")
                             , all attributes except "oninput" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := checkFloatWellformedness( req );
    if( errors == null ){
      errors := f.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := checkFloatWellformedness( req );
    if( errors == null ){
      errors := f.getValidationErrors();
      getPage().enterLabelContext( id );
      validatetemplate( elements );
      getPage().leaveLabelContext();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

function checkIntWellformedness( req: String ): [String]{
  var errors: [String] := null;
  if( req != null ){
    if( /-?\d+/.match( req ) ){
      if( req.parseInt() == null ){
        errors := [ "Outside of possible number range" ];
      }
    }
    else{
      errors := [ "Not a valid number" ];
    }
  }
  return errors;
}
template inputajax( i: ref Int ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputIntInternal( i, id )[ oninput = validator(); "" + attribute("oninput")
                           , all attributes except "oninput" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := checkIntWellformedness( req );
    if( errors == null ){
      errors := i.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := checkIntWellformedness( req );
    if( errors == null ){
      errors := i.getValidationErrors();
      getPage().enterLabelContext( id );
      validatetemplate( elements );
      getPage().leaveLabelContext();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

function checkLongWellformedness( req: String ): [String]{
  var errors: [String] := null;
  if( req != null ){
    if( /-?\d+/.match( req ) ){
      if( req.parseLong() == null ){
        errors := [ "Outside of possible number range" ];
      }
    }
    else{
      errors := [ "Not a valid number" ];
    }
  }
  return errors;
}
template inputajax( l: ref Long ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputLongInternal( l, id )[ oninput = validator(); "" + attribute("oninput")
                            , all attributes except "oninput" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := checkLongWellformedness( req );
    if( errors == null ){
      errors := l.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := checkLongWellformedness( req );
    if( errors == null ){
      errors := l.getValidationErrors();
      getPage().enterLabelContext( id );
      validatetemplate( elements );
      getPage().leaveLabelContext();
      errors.addAll(getPage().getValidationErrorsByName( id ));
    }
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

template inputajax( s: ref Secret ){
  inputajax( s as ref String )[ all attributes ]{ elements }
}
template inputajax( s: ref URL ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputURLInternal( s, id )[ oninput = validator(); "" + attribute("oninput")
                             , all attributes except "oninput" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := checkURLWellformedness( req );
    if( errors == null ){
      errors := s.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := checkURLWellformedness( req );
    if( errors == null ){
      errors := s.getValidationErrors();
      getPage().enterLabelContext( id );
      validatetemplate( elements );
      getPage().leaveLabelContext();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

function checkURLWellformedness( req: String ): [String]{
  var errors: [String] := null;
    if( req != null ){
      if( ! (req as URL).isValid() ){
        errors := [ "Malformed URL, make sure the protocol (e.g. http:// or https://) is included" ];
      }
    }
  return errors;
}

template inputajax( s: ref Text ){
  inputajax( s as ref String )[ all attributes ]{ elements }
}
template inputajax( s: ref WikiText ){
  inputajax( s as ref String )[ all attributes ]{ elements }
}
template inputajax( s: ref String ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputStringInternal( s, id )[ oninput = validator(); "" + attribute("oninput")
                              , all attributes except "oninput" ]
  //handle validations passed in call to this template
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := s.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := s.getValidationErrors();
    //ignore-validation prevents regular validation, manually execute validate phase for elements
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}
function checkEmailWellformedness( req: String ): [String]{
  var errors: [String] := null;
    if( req != null ){
      if( ! (req as Email).isValid() ){
        errors := [ "Not a valid email address" ];
      }
    }
  return errors;
}
template inputajax( s: ref Email ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputEmailInternal( s, id )[ oninput = validator(); "" + attribute("oninput")
                             , all attributes except "oninput" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := checkEmailWellformedness( req );
    if( errors == null ){
      errors := s.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := checkEmailWellformedness( req );
    if( errors == null ){
      errors := s.getValidationErrors();
      getPage().enterLabelContext( id );
      validatetemplate( elements );
      getPage().leaveLabelContext();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

template inputajax( set: ref {Entity} ){
  selectcheckboxajax( set, set.getAllowed() )[ all attributes ]{ elements }
}
template inputajax( set: ref {Entity}, from: [Entity] ){
  selectcheckboxajax( set, from )[ all attributes ]{ elements }
}
template selectcheckboxajax( set: ref {Entity} ){
  selectcheckboxajax( set, set.getAllowed() )[ all attributes ]{ elements }
}
template selectcheckboxajax( set: ref {Entity}, from: [Entity] ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputCheckboxSetInternal( set, from, id )[ onclick = validator(); "" + attribute("onclick")
                                           , all attributes except "onclick" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := set.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := set.getValidationErrors();
    //ignore-validation prevents regular validation, manually execute validate phase for elements
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}
template selectajax( ent: ref {Entity} ){
  selectajax( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template selectajax( set: ref {Entity}, from: [Entity] ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputSelectMultipleInternal( set, from, id )[ onchange = validator(); "" + attribute("onchange")
                                              , all attributes except "onchange" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := set.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := set.getValidationErrors();
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

template inputajax( ent: ref Entity ){
  selectajax( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template inputajax( ent: ref Entity, from: [Entity] ){
  selectajax( ent, from )[ all attributes ]{ elements }
}
template selectajax( ent: ref Entity ){
  selectajax( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template selectajax( ent: ref Entity, from: [Entity] ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputEntityInternal( ent, from, id )[ onchange = validator(); "" + attribute("onchange")
                                      , all attributes except "onchange" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := ent.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := ent.getValidationErrors();
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

template radioajax( ent: ref Entity ){
  radioajax( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template radioajax( ent1: ref Entity, ent2: [Entity] ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  radioInternal( ent1, ent2, id )[ onchange = validator(); "" + attribute("onchange")
                                 , all attributes except "onchange" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := ent1.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := ent1.getValidationErrors();
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

template inputajax( ent: ref [Entity] ){
  inputajax( ent, ent.getAllowed() )[ all attributes ]{ elements }
}
template inputajax( list: ref [Entity], from: [Entity] ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputListInternal( list, from, id )[ onchange = validator(); "" + attribute("onchange")
                                     , all attributes except "onchange" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages( errors )
    }
  }
  validate{
    errors := list.getValidationErrors();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := list.getValidationErrors();
    getPage().enterLabelContext( id );
    validatetemplate( elements );
    getPage().leaveLabelContext();
    errors.addAll( getPage().getValidationErrorsByName( id ) );
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

function checkSDFWellformedness( req: String, language: String ): [String]{
  var errors: [String] := null;
  if(    req != null
      && ! SDF.get( language ).isValid( req )
  ){
    errors := [ SDF.get( language ).getSGLRError( req ) ];
  }
  return errors;
}
template inputSDFajax( s: ref Text, language: String ){
  var req := getRequestParameter( id )
  request var errors: [String] := null
  inputTextInternal( s, id )[ inputSDF attributes
                            , oninput = validator(); "" + attribute("oninput")
                            , all attributes except "oninput" ]
  validate{ getPage().enterLabelContext( id ); }
  elements
  validate{ getPage().leaveLabelContext(); }
  placeholder "validate" + id{
    if( errors != null && errors.length > 0 ){
      showMessages(errors)
    }
  }
  validate{
    errors := checkSDFWellformedness( req, language );
    if( errors == null ){
      errors := s.getValidationErrors();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      cancel();
    }
  }
  action ignore-validation validator(){
    errors := checkSDFWellformedness( req, language );
    if( errors == null ){
      errors := s.getValidationErrors();
      getPage().enterLabelContext( id );
      validatetemplate( elements );
      getPage().leaveLabelContext();
      errors.addAll( getPage().getValidationErrorsByName( id ) );
    }
    if( errors.length > 0 ){
      replace( "validate" + id, showMessages( errors ) );
    }
    else{
      replace( "validate" + id, noMessages() );
    }
    rollback();
  }
}

//validation message templates

template errorTemplateInput( messages: [String] ){
  block{
    elements
    for( ve in messages ){
      block[ style := "color: #FF0000" ]{
        text(ve)
      }
    }
  }
}

template errorTemplateForm( messages: [String] ){
  block{
    for( ve in messages ){
      block[ style := "color: #FF0000;" ]{
        text(ve)
      }
    }
  }
}

template errorTemplateAction( messages: [String] ){
  block{
    for( ve in messages ){
      block[ style := "color: #FF0000;" ]{
        text(ve)
      }
    }
    elements
  }
}

template templateSuccess( messages: [String] ){
  block{
    for( ve in messages ){
      block[ style := "color: #BB8800;" ]{
        text(ve)
      }
    }
  }
}

template messages(){
  request var list: [String] := List<String>()
  render{
    list.addAll( getDispatchServlet().getIncomingSuccessMessages() );
    list.addAll( getDispatchServlet().getOutgoingSuccessMessages() ); //in case there are new messages created within this request
    getDispatchServlet().clearSuccessMessages();    
  }
  if( list.length > 0 ){
    templateSuccess( list )
  }
}

//execute the given javascript when document is ready, _and_ after ajax replace
//the passed node is either the document or the replacement node when using ajax
template postProcess(jsAsString : String){
	<script>
	(function(){
		var post_process_function = function(n){ var node=(n&&n instanceof HTMLElement)?n:document; ~jsAsString };
		var original_post_process_func = ajax_post_process;
		ajax_post_process = function(){
			original_post_process_func.apply(this,arguments)
			post_process_function(arguments);
		};
		$(document).ready( post_process_function );
	})();		
	</script>
}

//page description

template description(){
  includeHead( "<meta name='description' content='" + /'/.replaceAll( "&#39;", rendertemplate( elements ) ) + "'>" )
}

//page not found page

page pagenotfound(){
  <h3> "404 Not Found" </h3>
}

//access denied page

page accessDenied(){
  title{ "Access Denied" }
  text( "Access Denied: " )
  navigate root() { "return to home page" }
}

//default access control rule

access control rules
  rule page accessDenied(){ true }
  rule page pagenotfound(){ true }
  rule template *(*){ true }

  //Because [String] argument will already be part of the URL,
  //access control is not necessary for showMessages ajaxtemplate.
  //Tampering with the URL will produce an html-escaped echo of the 'list' request parameter.
  rule ajaxtemplate showMessages( list: [String] ){ true }
  rule ajaxtemplate noMessages(){ true }
