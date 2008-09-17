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
  return escape(encodeURI(string).replace(/%20/g,"+"));  //stupid replace because of difference between urlencode, en post encoding (see http://www.devpro.it/examples/php_js_escaping.php), 
                                                        //using regexp to replaceAll
}

function formToPost(formObj) {
  var request = "";
  for (var i = 0; i < formObj.length; i++) 
    if (formObj.elements[i].name != "")
    {
      if (formObj.elements[i].type=="select-multiple")
      {
        for(var j=0; j < formObj.elements[i].options.length; j++)
          if (formObj.elements[i].options[j].selected)
            request += formObj.elements[i].name + "=" + encodePost(formObj.elements[i].options[j].value) +"&";
      }
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
  while(current != null && current.id != "this")
    current = current.parentNode;
  
  result = null;
  if(current != null)
    result = findTopDown(current, id);
  
  //nothing found, search in the whole document
  if (result == null) 
    result = document.getElementById(id);
 
  return result;
}

function findTopDown(element, id)
{
  if (element.id != undefined && element.id == id)
    return element;

  if (element.childNodes != undefined)
    for(var i = 0; i< element.childNodes.length; i++)
      if (element.childNodes[i].nodeType == 1) //element node
        return findTopDown(element.childNodes[i], id);
}

function serverInvoke(template, action, jsonparams, thisform, thisobject)
{
  req = newRequest();
  req.open("POST", template , true);
  req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  //    http_request.setRequestHeader("Content-length", parameters.length);
  req.setRequestHeader("Connection", "close");
  
  req.onreadystatechange = function()
  {
    if (this.readyState == 4 && this.status == 200) {
       clientExecute(this.responseText, thisobject);
    }
    else if(this.readyState == 4 && this.status != 200) {
      notify('Invalid return of server: '+this.status); 
    }
  }
  
  //send a form if applicable
  formdata = "";
  if (thisform !='')
    formdata = formToPost(findElementById(thisobject, thisform));
  
  req.send(action+"=1&"+jsonparams+formdata);
}

function notify(string)
{
  alert(string);
}

function clientExecute(jsoncode, thisobject)
{
  data = eval(jsoncode);
  for(i = 0; i < data.length ; i++)
  {
    command = data[i];

    if (command.action == "replace")
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
      }
    }
        
    else if (command.action == "relocate")
      window.location = command.value;
    
   //other actions 
    
    else if (command.action != undefined) //last command might equal {}
      alert("unknown client command: "+command.action);
  }
}