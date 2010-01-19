//function which will be invoked after execute replace or append
var __ajax_postprocessor = null;

function ajax_post_process(node) {
  // node.scrollIntoView();
  if(show_webdsl_debug){
    if(typeof(console) != "undefined") {
      console.debug("Applied ajax transformation");
    }
  }
  if (__ajax_postprocessor != null) {
    __ajax_postprocessor(node);
  } 
} 

function formToJSON(formObj) {
  var request = "{";
  for (var i = 0; i < formObj.length; i++) 
    if (formObj.elements[i].name != "")
    {
      if (formObj.elements[i].type=="select-multiple")
      {
        request = request + "\""+formObj.elements[i].name+"\" : [ ";
        for(var j=0; j < formObj.elements[i].options.length; j++)
          if (formObj.elements[i].options[j].selected)
            request = request + formObj.elements[i].options[j].value +",";
        request = request.substr(0, request.length-1)+"]";
      }
      else
        request = request + "\""+formObj.elements[i].name+"\" : \""+ formObj.elements[i].value + "\"";
      if (i < formObj.length -1)
        request += ",";
    }
  request = request+ "}";
  //alert(request);
  return request;
};

function encodePost(string)
{
    if (string == undefined) 
      return "";
    return escape(Utf8.encode(string).replace(/\+/g,"%2B"));
 // return escape(encodeURI(string).replace(/%20/g,"+"));  //stupid replace because of difference between urlencode, en post encoding (see http://www.devpro.it/examples/php_js_escaping.php), 
                                                        //using regexp to replaceAll
}

function formToPost(formObj) {
  var request = "";
  for (var i = 0; i < formObj.length; i++) 
    if (formObj.elements != undefined && formObj.elements[i] != undefined && formObj.elements[i].name != "")
    {
      if (formObj.elements[i].type=="select-multiple")
      {
        for(var j=0; j < formObj.elements[i].options.length; j++)
          if (formObj.elements[i].options[j].selected)
            request += formObj.elements[i].name + "=" + encodePost(formObj.elements[i].options[j].value) +"&";
      }
      else if (formObj.elements[i].type=="checkbox")
      {
        if (formObj.elements[i].checked == true)
          request = request + formObj.elements[i].name + "=1&";
      }
      else if (formObj.elements[i].nodeName.toLowerCase() == "textarea") {
        request = request + formObj.elements[i].name + "=" + encodePost(formObj.elements[i].value) + "&";
      }
      //exclude submit buttons
      else if (formObj.elements[i].nodeName.toLowerCase() == "input" 
               && formObj.elements[i].type=="submit"){}
      else
        request = request + formObj.elements[i].name + "=" + encodePost(formObj.elements[i].value) + "&";
    }
  //alert(request);
  return request;
};

function newRequest()
{
  xmlHttp = null;

  try {	xmlHttp = new XMLHttpRequest();  } catch (e) {
    try {  xmlHttp=new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {
       xmlHttp=new ActiveXObject("Microsoft.XMLHTTP"); }	 }
  return xmlHttp;

}

function findElementById(thisobject, id)
{
  //step one, find the right parent to search within
  current = thisobject;
  if (current == null) {
    current = window.document.body;
  }
  result = null;
  foundscope = false;
  while(current != null && !foundscope && result == null) {
    //while going up in the tree, found the id. 
    if (current.id != undefined && current.id == id) { 
      result = current;
    }
    //found the scope boundary of this template, search inward
    else if (current.className && current.className.indexOf("scopediv") != -1) {
      foundscope = true;
      if (id == "this") 
        result = current;
      else
        result = findTopDown(current, id);
    } 
    current = current.parentNode;
  }  	
  
  //nothing found, search upwards, to the closest enclosing node with the proper id
  //useful in recursion
  if (result == null) {
    current = thisobject;
    while (current.parentNode != null) {
      current = current.parentNode;
      if (current.id != undefined && current.id == id)
        return current;
    }
   }
  
  //nothing found, search in the whole document
  if (result == null) 
    result = document.getElementById(id);
 
  if (result == null)
    if(show_webdsl_debug){ alert("Object with id '"+id+"' does not exist in the document!"); }
      
  return result;
}

function findTopDown(element, id)
{
  if (element.childNodes != undefined) {
    for(var i = 0; i< element.childNodes.length; i++) {
      var child = element.childNodes[i];
      if (child.id != undefined && child.id == id)
        return child;
    }
    for(var i = 0; i< element.childNodes.length; i++)
      if (element.childNodes[i].nodeType == 1) { //element node
        result = findTopDown(element.childNodes[i], id);
        if (result != null)
          return result;
      }
  }
  return null;
}

function serverInvoke(template, action, jsonparams, thisform, thisobject)
{
  loadingimage = startLoading(thisobject);
  serverInvokeCommon(template, action, jsonparams, thisform, thisobject, 
    function()
    {
      if (this.readyState == 4 && this.status == 200) {
         clientExecute(this.responseText, thisobject);
         stopLoading(thisobject, loadingimage);
      }
      else if(this.readyState == 4 && this.status != 200) {
        notify('Invalid return of server: '+this.status); 
      }
    }
  );
}

function serverInvokeCommon(template, action, jsonparams, thisform, thisobject, callback)
{
  req = newRequest();
  req.open("POST", template , true);
  req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  req.setRequestHeader("charset", "UTF-8");  
  //    http_request.setRequestHeader("Content-length", parameters.length);
  req.setRequestHeader("Connection", "close");
  
  req.onreadystatechange = callback;
  
  data = createData(action,jsonparams,thisform,thisobject);
  
  req.send(data);
}

function startLoading(thisobject){
  var container = document.createElement("div");
  var image = document.createElement("img");
  image.src = contextpath+"/images/ajax-loader.gif";
  container.appendChild(image);
  container.style.display = 'inline';
  thisobject.appendChild(container);
  thisobject.disabled = true;
  thisobject.temp_onclick = thisobject.onclick;
  thisobject.onclick = "false;";
  return container;
}

function stopLoading(thisobject, loadingimage){
  thisobject.removeChild(loadingimage);
  thisobject.disabled=false;
  thisobject.onclick = thisobject.temp_onclick;
}

function createData(action,jsonparams,thisform,thisobject)
{
  data = action+"=1&"+jsonparams;
  //send a form if applicable
  if (thisform !='')
    data += formToPost(findElementById(thisobject, thisform));
  //remove trailing &
  if (data.charAt(data.length-1) == '&')
    data = data.substr(0, data.length -1);
  return data;
}

function serverInvokeDownloadCompatible(template, action, jsonparams, thisform, thisobject)
{
  // Create an IFRAME.
  var iframe = document.createElement("iframe");

  // This makes the IFRAME invisible to the user.
  iframe.style.display = "none";
 
  //encode form data
  data = createData(action,jsonparams,thisform,thisobject);
 
  // Point the IFRAME to the action invoke
  iframe.src = template+"?action-call-with-get-request-type=1&"+data; 
  
  // Add the IFRAME to the page. This will trigger a request to the action now.
  document.body.appendChild(iframe); 
  
}

function clientExecute(jsoncode, thisobject)
{
  data = eval(jsoncode);
  if (data == undefined)
    if(show_webdsl_debug){ alert("received no valid response from the server! "+jsoncode); }
  for(i = 0; i < data.length ; i++)
  {
    command = data[i];

    if (command.action == "replace")
      replace(command, thisobject);
    else if (command.action == "append")
      append(command, thisobject);
    else if (command.action == "clear")
      clear(command, thisobject);
    else if (command.action == "visibility")
      changevisibility(command, thisobject);        
    else if (command.action == "relocate")
      relocate(command);
    else if (command.action == "restyle")
      restyle(command, thisobject);
    else if (command.action == "refresh") 
      location.reload(true);
    //used for displaying validation messages
    else if (command.action == "replaceall") {
      replaceall(command);
    }
    else if (command.action == "runscript") {
      eval(command.value);
    }
    //other actions 
    
    else if (command.action != undefined) //last command might equal {}
      if(show_webdsl_debug){ alert("unknown client command: "+command.action); }
  }
}

function notify(string)
{
  if(show_webdsl_debug){ alert(string); }
}

function replaceall(command) {
    var theNode = window.document.documentElement;

    var newElem = document.createElement("tmp"); 
    newElem.innerHTML = unescape(command.value);
    theNode.innerHTML = newElem.innerHTML;
    
    ajax_post_process(theNode);
}

function replace(command, thisobject)
{
    var theNode = findElementById(thisobject, command.id);
    if (command.id != "this")
      theNode.innerHTML = unescape(command.value);
    else //this has other semantics
    {
      var newElem = document.createElement("tmp"); 
      newElem.innerHTML = unescape(command.value);
      theNode.parentNode.replaceChild(newElem.childNodes[0], theNode); //wrapper node "this" always available
      //note that this might break with no template based replacements
      theNode = newElem.childNodes[0];
    }
    
    ajax_post_process(theNode);
}

function append(command, thisobject)
{
    var theNode = findElementById(thisobject, command.id);
    if (command.id != "this")
      theNode.innerHTML += unescape(command.value);
    else //this has other semantics
    {
      var newElem = document.createElement("tmp"); 
      newElem.innerHTML = unescape(command.value);
      theNode.parentNode.appendChild(newElem.childNodes[0], theNode); //wrapper node "this" always available
      //note that this might break with no template based replacements
      theNode = newElem.childNodes[0];
    }
    
    ajax_post_process(theNode);
}

function clear(command, thisobject)
{
  var theNode = findElementById(thisobject, command.id);
  while (theNode.hasChildNodes())
  {
    theNode.removeChild(theNode.firstChild);
  }  
}

var cachedDisplays = new Object(  ); //stores the default display stiles

function changevisibility(command, thisobject)
{
    var theNode = findElementById(thisobject, command.id);
    
    if (command.value == "toggle")
    {
      if (theNode.style.display == "none")
        command.value = "show";
      else
        command.value = "hide";
    }       
    
    if (command.value == "hide" && theNode.style.display != "none")
    {
      cachedDisplays[command.id] = theNode.style.display; //cache the style visibility
      theNode.style.display = "none";
    }
    else if (command.value == "show" && theNode.style.display == "none")
    {
      if (cachedDisplays[command.id] != undefined)
        theNode.style.display = cachedDisplays[command.id];
      else
        theNode.style.display = "block"; //default if cache not found (e.g. the object started as being invisible)
    } 
}

function restyle(command, thisobject)
{
   var theNode = findElementById(thisobject, command.id);
   theNode.className = command.value;
}

function relocate(command)
{
  window.location = command.value;
}

function loadCSS(url) {
    e = document.createElement("link");
    e.setAttribute("rel", "stylesheet")
    e.setAttribute("type", "text/css")
    e.setAttribute("href", url)
    document.getElementsByTagName("head")[0].appendChild(e);  	
}

//UTF encoding: http://www.webtoolkit.info/javascript-utf8.html
var Utf8 = {
  // public method for url encoding
  encode : function (string) {
    if (string == null) 
      return "";
    string = string.replace(/\r\n/g,"\n");
    var utftext = "";
    for (var n = 0; n < string.length; n++) {
      var c = string.charCodeAt(n);
      if (c < 128) {
        utftext += String.fromCharCode(c);
      }
      else if((c > 127) && (c < 2048)) {
        utftext += String.fromCharCode((c >> 6) | 192);
        utftext += String.fromCharCode((c & 63) | 128);
      }
      else {
        utftext += String.fromCharCode((c >> 12) | 224);
        utftext += String.fromCharCode(((c >> 6) & 63) | 128);
        utftext += String.fromCharCode((c & 63) | 128);
      }
    }
    return utftext;
  },
  // public method for url decoding
  decode : function (utftext) {
    var string = "";
    var i = 0;
    var c = c1 = c2 = 0;
    while ( i < utftext.length ) {
      c = utftext.charCodeAt(i);
      if (c < 128) {
        string += String.fromCharCode(c);
        i++;
      }
      else if((c > 191) && (c < 224)) {
        c2 = utftext.charCodeAt(i+1);
        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
        i += 2;
      }
      else {
        c2 = utftext.charCodeAt(i+1);
        c3 = utftext.charCodeAt(i+2);
        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
        i += 3;
      }
    }
    return string;
  }
};
