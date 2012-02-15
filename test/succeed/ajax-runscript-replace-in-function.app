application test

define page root(){
	animate()
	
	placeholder q{
		"test"
	}
}

define animate (){
  includeJS("jquery-1.5.min.js")
  includeJS("jquery-ui-1.8.9.custom.min.js")
  includeCSS("jquery-ui.css")
  submit action{animate();}{"animate"}
}

define ajax empty(){
	
}

function animate(){
	runscript("$('q').animate({left:'10', top:'10'},1000);");
	replace(q, empty());
}