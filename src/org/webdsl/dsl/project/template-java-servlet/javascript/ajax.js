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

function newRequest()
{
	xmlHttp = null;
	try {	xmlHttp = new XMLHttpRequest();  } catch (e) {
		try {  xmlHttp=new ActiveXObject("Msxml2.XMLHTTP"); } catch (e) {
		   xmlHttp=new ActiveXObject("Microsoft.XMLHTTP"); }	 }
	return xmlHttp;

}

function loaddiv(div, call)
{
	req = newRequest();
	
  req.open("GET", call, true);
  req.onreadystatechange = function()
  {
   	if (req.readyState == 4) {
	    document.getElementById(div).innerHTML =  req.responseText;
    }
    else if(req.readyState != 1) {
    	document.getElementById(div).innerHTML = 'Invalid return of server: '+req.readyState; 
    }
  }
  req.send(null);
}
