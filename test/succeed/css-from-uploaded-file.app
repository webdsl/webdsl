application cssApp

page root(){
	var cssfs := from CSSFile;
	
	if(cssfs.length > 0){
	  includeCSS( navigate( cssDownload( cssfs.get(0), cssfs.get(0).name +".css" ) ) )
	}
	
	<h1>"BOOMING"</h1>
}


entity CSSFile{
  name : String
  file : File
  
  cache
}

page cssDownload( f : CSSFile, name : String){
	init{
		f.file.download();
	}
}

derive crud CSSFile