application test

define page root(){
	animate(q)
	
	placeholder q{
		"test"
	}
}

define animate(pl: Placeholder){
  includeJS("jquery-1.8.2.min.js")
  includeJS("jquery-ui-1.9.1.custom.min.js")
  includeCSS("jquery-ui-1.9.1.custom.min.css")
  submit action{animate(pl);}{"animate"}
}

define ajax empty(){
	
}

function animate(p: String){
	runscript("$('"+p+"').animate({left:'10', top:'10'},1000);");
	replace(p, empty());
}