function ajax_post_process(node) {
  //script tags, such as for datepicker init, are not evaluated when inserted with ajax, this is a workaround that explicitly runs the script contents
  var inner = node.innerHTML;
  if (inner.indexOf("<script") >= 0) {
    var response = $(node);
    var responseScript = response.filter("script").add(response.find("script"));
    $.each(responseScript, function(idx, val) {
      try {
        eval(val.text);
      } catch (err) {
        console.log("Error evaluating javascript as part of ajax response:\n" + err);
      }
    });
  }
}

function formToJSON(formObj) {
  var request = "{";
  for (var i = 0; i < formObj.length; i++)
    if (formObj.elements[i].name != "") {
      if (formObj.elements[i].type == "select-multiple") {
        request = request + "\"" + formObj.elements[i].name + "\" : [ ";
        for (var j = 0; j < formObj.elements[i].options.length; j++)
          if (formObj.elements[i].options[j].selected)
            request = request + formObj.elements[i].options[j].value + ",";
        request = request.substr(0, request.length - 1) + "]";
      } else
        request = request + "\"" + formObj.elements[i].name + "\" : \"" + formObj.elements[i].value + "\"";
      if (i < formObj.length - 1)
        request += ",";
    }
  request = request + "}";
  //alert(request);
  return request;
};

function encodePost(string) {
  if (string == undefined)
    return "";
  return escape(Utf8.encode(string)).replace(/\+/g, "%2B"); // + is not being encoded, but will be incorrectly interpreted as a space
  // return escape(encodeURI(string).replace(/%20/g,"+"));  //stupid replace because of difference between urlencode, en post encoding (see http://www.devpro.it/examples/php_js_escaping.php),
  //using regexp to replaceAll
}

function formToPost(formObj) {
  var request = "";
  var showFileUploadNotSupported = false;
  for (var i = 0; i < formObj.length; i++)
    if (formObj.elements != undefined && formObj.elements[i] != undefined && formObj.elements[i].name != "") {
      if (formObj.elements[i].type == "select-multiple") {
        for (var j = 0; j < formObj.elements[i].options.length; j++)
          if (formObj.elements[i].options[j].selected)
            request += formObj.elements[i].name + "=" + encodePost(formObj.elements[i].options[j].value) + "&";
      } else if (formObj.elements[i].type == "checkbox") {
        if (formObj.elements[i].checked == true)
          request = request + formObj.elements[i].name + "=1&";
      } else if (formObj.elements[i].type == "radio") {
        if (formObj.elements[i].checked == true)
          request = request + formObj.elements[i].name + "=" + formObj.elements[i].value + "&";
      } else if (formObj.elements[i].nodeName.toLowerCase() == "textarea") {
        request = request + formObj.elements[i].name + "=" + encodePost(formObj.elements[i].value) + "&";
      }
      //exclude submit/button
      else if ((formObj.elements[i].nodeName.toLowerCase() == "input" && (formObj.elements[i].type == "submit" || formObj.elements[i].type == "button")) ||
        formObj.elements[i].nodeName.toLowerCase() == "button") {
      } else if (formObj.elements[i].nodeName.toLowerCase() == "input" && formObj.elements[i].type == "file") {
        showFileUploadNotSupported = formObj.elements[i].value != "";
      } else
        request = request + formObj.elements[i].name + "=" + encodePost(formObj.elements[i].value) + "&";
    }

  if (showFileUploadNotSupported) {
    var browserSupportsFormData = window.FormData !== undefined;
    if( browserSupportsFormData ){
      doShowError('Something went wrong. The files could not be uploaded through this action.');
    } else {
      doShowError('You are using an (older) browser that does not support file uploads in this form');
    }
  }
  //alert(request);
  return request;
};

function clickFirstButton(formObj) {
  for (var i = 0; i < formObj.length; i++) {
    if (formObj.elements != undefined && formObj.elements[i] != undefined) {
      if (formObj.elements[i].nodeName.toLowerCase() == "input" && formObj.elements[i].type == "submit") {
        return true; //just let the normal form submit proceed
      }
      if (formObj.elements[i].nodeName.toLowerCase() == "input" && formObj.elements[i].type == "button") {
        formObj.elements[i].click();
        return false;
      }
    }
  }
  return false;
}

function newRequest() {
  xmlHttp = null;

  try {
    xmlHttp = new XMLHttpRequest();
  } catch (e) {
    try {
      xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
      xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
  }
  return xmlHttp;

}

function findEnclosingPlaceholder(thisobject) {
  current = thisobject;
  result = null;
  while (current != null && result == null) {
    if (current.className && current.className.indexOf("webdsl-placeholder") != -1) {
      result = current;
    } else {
      current = current.parentNode;
    }
  }
  return result;
}

function findOuterEnclosingElement(thisobject, attrname, value) {
  current = thisobject;
  result = null;
  while (current != null && current.tagName != "HTML") {
    if (current.getAttribute(attrname) == value) {
      result = current;
    }
    current = current.parentNode;
  }
  return result;
}

function findElementById(thisobject, id) {
  //step one, find the right parent to search within
  current = thisobject;
  if (current == null) {
    current = window.document.body;
  }
  result = null;
  foundscope = false;
  while (current != null && !foundscope && result == null) {
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
    if (show_webdsl_debug) {
      alert("Object with id '" + id + "' does not exist in the document!");
    }

  return result;
}

function findTopDown(element, id) {
  if (element.childNodes != undefined) {
    for (var i = 0; i < element.childNodes.length; i++) {
      var child = element.childNodes[i];
      if (child.id != undefined && child.id == id)
        return child;
    }
    for (var i = 0; i < element.childNodes.length; i++)
      if (element.childNodes[i].nodeType == 1) { //element node
        result = findTopDown(element.childNodes[i], id);
        if (result != null)
          return result;
      }
  }
  return null;
}

var __skip_next_action = false;
var __next_action = false;

function serverInvoke(template, action, jsonparams, thisform, thisobject, loadfeedback, placeholderId) {
  var attachObj, loadingimage;
  __skip_next_action = false;
  if (loadfeedback) {
    attachObj = typeof loadImageElem !== 'undefined' ? loadImageElem : thisobject;
    loadImageElem = undefined;
    loadingimage = startLoading(attachObj);
  }
  serverInvokeCommon(template, action, jsonparams, thisform, thisobject, placeholderId,
    function(req) {
      if (req.readyState == 4) {
        if (req.status == 200) {
          clientExecute(req.responseText, thisobject);
        } else if (req.status == 413) {
          doShowError('The file is too large to upload. Please try compressing the file or uploading a smaller selection.');
        } else {
          showError(thisobject, 'Error while handling this action, the server returned status ' + req.status + '. The action may no longer be available. Copy your unsaved changes before leaving/refreshing this page.');
        }
        if (loadfeedback) {
          stopLoading(attachObj, loadingimage);
        }
        __requestcount--;
        // handle multiple submit actions for inputajax
        if( __next_action !== false ){
          if( ! __skip_next_action ){
            __next_action();
          }
          __next_action = false;
        }
      }
    }
  );
}


function showError(thisobject, genericError) {
  var msg = window.actionFailureMessage !== undefined ? actionFailureMessage : genericError;
  var thisobjectSpecificError = $(thisobject).data('action-failed');

  if (thisobjectSpecificError !== undefined)
    msg = thisobjectSpecificError;

  doShowError(msg);
}

function doShowError(msg) {
  notify(msg);
  var dismissHTML = "<a href=\"javascript:$('.action-failure-msg').fadeOut();void(0)\" style=\"margin-left: 15px;\">Dismiss</a>";
  var errorElem = $("<span class=\"action-failure-msg\" style=\"display: none;\">" + msg + dismissHTML + "</span>");
  $('body').append(errorElem);
  errorElem.fadeIn();
}

var __requestcount = 0;

function serverInvokeCommon(template, action, jsonparams, thisform, thisobject, placeholderId, callback) {
  var supportsFormData = window.FormData !== undefined;
  __requestcount++;

  if (supportsFormData) {
    $.ajax({
      type: 'POST',
      method: 'POST',
      cache: false,
      contentType: false,
      processData: false,
      url: template,
      data: createFormData(action, jsonparams, thisform, thisobject, placeholderId),
      complete: callback
    });
  } else {
    req = newRequest();
    req.open("POST", template, true); //chosen for always asynchronous (true), even for testing, to have tested system as close to real thing as possible, also synchronous/false doesn't seem to work with WebDriver currently. The downside is that tests with ajax calls need sleeps to wait for the response.
    req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    req.setRequestHeader("charset", "UTF-8");

    req.onreadystatechange = function() {
      callback(this);
    };

    data = createData(action, jsonparams, thisform, thisobject, placeholderId);

    req.send(data);
  }
}

function createFormData(action, jsonparams, thisform, thisobject, placeholderId) {
  var theForm = (thisform != '') ? findElementById(thisobject, thisform) : null;
  var formdata = theForm ? new FormData(theForm) : new FormData();
  $.each(jsonparams, function(key, val) {
    formdata.append(val.name, val.value)
  });

  if (action != '') {
    formdata.append(action, "1");
    formdata.append("__ajax_runtime_request__", placeholderId);
  } else {
    formdata.append("post-request-no-action", 1);
  }
  return formdata;
}

function replaceWithoutAction(serviceURL, jsonData, idOfElemToReplace) {
  serverInvokeCommon(serviceURL, '', jsonData, '', '', '',
    function(req) {
      if (req.readyState == 4) {
        if (req.status == 200) {
          if(req.responseText.substring(0, 15) == "<!DOCTYPE html>"){
            //in case a html document is returned, don't do anything.
            console.log("Unexpected server response for " + serviceURL + ". Received complete document instead of partial document");
            return;
          }
          var theNode = document.getElementById(idOfElemToReplace);
          theNode.innerHTML = req.responseText;
          ajax_post_process(theNode);
        } else if (req.status != 200) {
          console.log("Unexpected server response for " + serviceURL + " status code: " + req.status);
//          showError(thisobject, 'Invalid return of server: ' + req.status);
        }
      }
    }
  );
}

var loadImageElem;

function startLoading(attachObj) {
  var div = document.createElement("div");
  div.innerHTML = '<div class="lds-ring"><div></div><div></div><div></div><div></div>' + loadingStyle + '</div>';
  var container = div.firstChild;
  container.style.display = 'inline';
  container.style.position = 'absolute';
  attachObj.appendChild(container);
  attachObj.disabled = true;
  attachObj.temp_onclick = attachObj.onclick;
  attachObj.onclick = "false;";
  return container;
}

function stopLoading(thisobject, loadingimage) {
  thisobject.removeChild(loadingimage);
  thisobject.disabled = false;
  thisobject.onclick = thisobject.temp_onclick;
}



function createData(action, jsonparams, thisform, thisobject, placeholderId) {
  if (action != '') {
    data = action + "=1&";
    data += "__ajax_runtime_request__="+placeholderId+"&";
  } else {
    data = "post-request-no-action=1&";
  }
  paramsdata = eval(jsonparams);
  if (paramsdata == undefined)
    if (show_webdsl_debug) {
      alert("invalid JSON page parameters in ajax action call: " + jsonparams);
    }
  for (i = 0; i < paramsdata.length; i++) {
    data += paramsdata[i].name + "=" + encodePost(paramsdata[i].value) + "&";
  }
  //send a form if applicable
  if (thisform != '')
    data += formToPost(findElementById(thisobject, thisform));
  //remove trailing &
  if (data.charAt(data.length - 1) == '&')
    data = data.substr(0, data.length - 1);
  return data;
}

function serverInvokeDownloadCompatible(template, action, jsonparams, thisform, thisobject, placeholderId) {
  // Create an IFRAME.
  var iframe = document.createElement("iframe");

  // This makes the IFRAME invisible to the user.
  iframe.style.display = "none";

  //encode form data
  data = createData(action, jsonparams, thisform, thisobject, placeholderId);

  // Point the IFRAME to the action invoke
  iframe.src = template + "?action-call-with-get-request-type=1&" + data;

  // Add the IFRAME to the page. This will trigger a request to the action now.
  document.body.appendChild(iframe);

}

function requireJSResource( uri, callback ){
  if( 1 > $('script[src="' + uri + '"]').length ){
    console.log("Dynamically loading: " + uri);
    var head = document.getElementsByTagName('head')[0];
    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = uri;
    script.onload = callback;
    script.onerror = callback;
    head.appendChild(script);
  } else {
    callback();
  }
}
function requireCSSResource( uri ){
  if( 1 > $('link[href="' + uri + '"]').length ){
    console.log("Dynamically loading: " + uri);
    var head = document.getElementsByTagName('head')[0];
    var link = document.createElement("link");
    link.type = "text/css";
    link.rel = "stylesheet";
    link.href = uri;
    head.appendChild(link);
  }
}

//load JS resources and defer calls to ajax_post_process until resources are loaded
function requireJSResources( arr ){
  var resourcesToLoad = arr.length;
  if(resourcesToLoad < 1){
    return;
  }

  var orig_ajax_post_process = ajax_post_process;
  var post_process_calls_queue = function(){};
  ajax_post_process = function( node ){
    var queue_head = post_process_calls_queue;
    post_process_calls_queue = function(){
      queue_head();
      orig_ajax_post_process(node);
    }
  }; 
   
  var nextIdx = 0;
  function tryLoadNextResource(){
    if(nextIdx >= resourcesToLoad){
      ajax_post_process = orig_ajax_post_process;
      post_process_calls_queue();
    } else {
      var resource = arr[nextIdx];
      nextIdx++;
      requireJSResource( resource, tryLoadNextResource );
    }
  }
  tryLoadNextResource();
}

function clientExecute(jsoncode, thisobject) {
  
  data = eval(jsoncode);
  if (data == undefined)
    if (show_webdsl_debug) {
      alert("received no valid response from the server! " + jsoncode);
    }

  for (var i = 0; i < data.length; i++) {
    command = data[i];
    try {
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
      } else if (command.action == "runscript") {
        eval(command.value);
      } else if (command.action == "logsql") {
        appendLogSql(command);
      } else if (command.action == "require_js") {
        requireJSResources( command.value );
      } else if (command.action == "require_css") {
        var arr = command.value;
        for (var j = 0; j < arr.length; j++) {
          requireCSSResource( arr[j] );
        }
      } else if (command.action == "skip_next_action") {
        __skip_next_action = true;
      } else if (command.action != undefined) //last command might equal {}
        if (show_webdsl_debug) {
          alert("unknown client command: " + command.action);
        }
    } catch (error) {
      console.log(error);
    }
  }
}

function notify(string) {
  if (show_webdsl_debug) {
    alert(string);
  }
  console.log(string);
}

function replaceall(command) {
  var theNode = window.document.body;
  theNode.innerHTML = command.value;
  ajax_post_process(theNode);
}

function replace(command, thisobject) {
  var theNode;

  if (command.id.type == "enclosing-placeholder") {
    theNode = findEnclosingPlaceholder(thisobject);
  } else if (command.id.submitid) {
    theNode = findOuterEnclosingElement(thisobject, "submitid", command.id.submitid);
    command.id = "this";
  } else {
    theNode = findElementById(thisobject, command.id);
  }

  if (command.id != "this") {
    theNode.innerHTML = command.value;
  } else {
    var newElem = document.createElement("tmp");
    newElem.innerHTML = command.value;
    var parent = theNode.parentNode;
    var index = Array.prototype.indexOf.call(parent.children, theNode);
    parent.replaceChild(newElem.childNodes[0], theNode);
    theNode = parent.childNodes[index];
  }

  ajax_post_process(theNode);
}

function append(command, thisobject) {
  if (command.value && command.value != "") {
    var theNode = findElementById(thisobject, command.id);
    if (command.id != "this") {
      var newElem = document.createElement("span");
      newElem.setAttribute("class", "appended");
      newElem.innerHTML = command.value;
      theNode.appendChild(newElem);
      theNode = newElem;
    } else //this has other semantics
    {
      var newElem = document.createElement("tmp");
      newElem.innerHTML = command.value;
      theNode.parentNode.appendChild(newElem.childNodes[0], theNode); //wrapper node "this" always available
      //note that this might break with no template based replacements
      theNode = newElem.childNodes[0];
    }
    ajax_post_process(theNode);
  }
}

function clear(command, thisobject) {
  var theNode = findElementById(thisobject, command.id);
  while (theNode.hasChildNodes()) {
    theNode.removeChild(theNode.firstChild);
  }
}

var cachedDisplays = new Object(); //stores the default display stiles

function changevisibility(command, thisobject) {
  var theNode = findElementById(thisobject, command.id);

  if (command.value == "toggle") {
    if (theNode.style.display == "none")
      command.value = "show";
    else
      command.value = "hide";
  }

  if (command.value == "hide" && theNode.style.display != "none") {
    cachedDisplays[command.id] = theNode.style.display; //cache the style visibility
    theNode.style.display = "none";
  } else if (command.value == "show" && theNode.style.display == "none") {
    if (cachedDisplays[command.id] != undefined)
      theNode.style.display = cachedDisplays[command.id];
    else
      theNode.style.display = "block"; //default if cache not found (e.g. the object started as being invisible)
  }
}

function restyle(command, thisobject) {
  var theNode = findElementById(thisobject, command.id);
  theNode.className = command.value;
}

function relocate(command) {
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
  encode: function(string) {
    if (string == null)
      return "";
    string = string.replace(/\r\n/g, "\n");
    var utftext = "";
    for (var n = 0; n < string.length; n++) {
      var c = string.charCodeAt(n);
      if (c < 128) {
        utftext += String.fromCharCode(c);
      } else if ((c > 127) && (c < 2048)) {
        utftext += String.fromCharCode((c >> 6) | 192);
        utftext += String.fromCharCode((c & 63) | 128);
      } else {
        utftext += String.fromCharCode((c >> 12) | 224);
        utftext += String.fromCharCode(((c >> 6) & 63) | 128);
        utftext += String.fromCharCode((c & 63) | 128);
      }
    }
    return utftext;
  },
  // public method for url decoding
  decode: function(utftext) {
    var string = "";
    var i = 0;
    var c = c1 = c2 = 0;
    while (i < utftext.length) {
      c = utftext.charCodeAt(i);
      if (c < 128) {
        string += String.fromCharCode(c);
        i++;
      } else if ((c > 191) && (c < 224)) {
        c2 = utftext.charCodeAt(i + 1);
        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
        i += 2;
      } else {
        c2 = utftext.charCodeAt(i + 1);
        c3 = utftext.charCodeAt(i + 2);
        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
        i += 3;
      }
    }
    return string;
  }
};

//avoid too many request while typing in a field with onkeyup trigger
var onkeyupdelay = function() {
  var timer = 0; //scoped inside this function block, triggering onkeyup again before timeout resets the timer for that particular action
  return function(callback) {
    clearTimeout(timer);
    timer = setTimeout(callback, (typeof onkeyupdelayoverride === 'undefined') ? 250 : onkeyupdelayoverride);
  }
}();

function appendLogSql(command) {
  var hr = document.createElement('hr');
  document.body.appendChild(hr);

  var div = document.createElement('div');
  div.className = 'logsql';
  div.innerHTML = command.value;
  document.body.appendChild(div);
}

//report error when character is not in Basic Multilingual Plane (BMP), and would encode as 4 bytes UTF-8
function checkForUnsupportedCharacters( textValue ){
  for (var i=0; i<textValue.length; i++) {
    if (textValue.codePointAt(i) > 65533) {
      doShowError("You entered text that contains a unicode character '" + String.fromCodePoint( textValue.codePointAt(i) ) + "' which is not supported.");
      return;
    }
  }
}

var loadingStyle = '\
<style>\
.lds-ring {\
  display: inline-block;\
  position: relative;\
  width: 32px;\
  height: 32px;\
}\
.lds-ring div {\
  box-sizing: border-box;\
  display: block;\
  position: absolute;\
  width: 24px;\
  height: 24px;\
  margin: 3px;\
  border: 3px solid #ddd;\
  border-radius: 50%;\
  animation: lds-ring 1.2s cubic-bezier(0.5, 0, 0.5, 1) infinite;\
  border-color: #ddd transparent transparent transparent;\
}\
.lds-ring div:nth-child(1) {\
  animation-delay: -0.45s;\
}\
.lds-ring div:nth-child(2) {\
  animation-delay: -0.3s;\
}\
.lds-ring div:nth-child(3) {\
  animation-delay: -0.15s;\
}\
@keyframes lds-ring {\
  0% {\
    transform: rotate(0deg);\
  }\
  100% {\
    transform: rotate(360deg);\
  }\
}\
</style>';