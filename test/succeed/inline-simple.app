// all these template calls should be inlined in .servletapp/src-generated/webdsl/generated/templates/inlinetest_Template.java 

application test

  page root(){
  	inlinetest()
  }
  
  template inlinetest(){
    divtest[class="a", style="border-style:dotted;"]{
  	divtest[class="b", style="border-style:solid;"]{
  	divtest[class="c", style="border-style:dashed;"]{
  	containertest[class="a", style="border-style:dotted;"]{
  	wrapper{
  	gridColMd(1,2){
  	gridColPush(3,4){
  	pullLeft{
  	navbarFluid{
  	gridRow{
  	group("testgroup"){
  	controlGroup("TESTcgroup"){
  	  "test"
  	   spacertest
  	   iArrowDown
  	}}}}}}}}}}}}
  }
  
  test{
  	var source := rendertemplate(inlinetest());
  	// check whether all the divs and spans show up, does not verify whether inlining occurred
  	assert(source.contains("<div class=\"a\" style=\"border-style:dotted;\"><div class=\"b\" style=\"border-style:solid;\"><div class=\"c\" style=\"border-style:dashed;\"><span class=\"container a\" style=\"border-style:dotted;\"><div><div class=\"col-md-1 col-md-offset-2 \"><div class=\"col-sm-3 col-sm-push-4\"><span class=\"pull-lef\"><div class=\"navbar navbar-inverse navbar-fixed-top\"><div class=\"navbar-inner\"><div class=\"container\"><div class=\"row\"><fieldset><legend>testgroup</legend><table><div class=\"control-group\">"));
    assert(source.contains("TESTcgroup</label><div class=\"controls\">test<hr/><span class=\"glyphicon glyphicon-arrow-down\"></span></div></div></table></fieldset></div></div></div></div></span></div></div></div></span></div></div></div>"));
  }

  define divtest(){ // test old syntax as well     
    <div all attributes>
      elements()
    </div>
  }

  define spacertest(){
    <hr all attributes/>
  }

  define ignore-access-control containertest(){ 
    <span class="container "+attribute("class")
         all attributes except "class">
      elements()
    </span>
  }
  
  template wrapper(){
    div{
      elements()
    }
  }
  
  template gridColMd(cols : Int, offset : Int){
    div[class="col-md-" + cols + " col-md-offset-" + offset + " " + attribute("class"), all attributes]{ elements }
  }
  
  template gridColPush(cols : Int, offset : Int){
   div[class="col-sm-" + cols + " col-sm-push-" + offset, all attributes]{ elements }
  }

  template pullLeft() {  
  	span[class="pull-lef", all attributes]{ elements }
  }

  template navbarFluid() {
    div[class="navbar navbar-inverse navbar-fixed-top"]{
      div[class="navbar-inner"]{
        div[class="container"]{
          elements
        }
      }
    }
  }

  template gridRow(){
  	div[class="row", all attributes]{ elements }
  }
  
  define iArrowDown(){ <span class="glyphicon glyphicon-arrow-down"></span> }
 
 
   // not inlined yet
   
   template controlGroup(s: String){
    div[class="control-group"]{
    	label(s)[class="control-label"]{ 
    		div[class="controls"]{
    		  elements
    		}
    	}
    }
  }

 /*
  define ignore-access-control grouptest(s:String){
    <fieldset all attributes>
      <legend>
        output(s)
      </legend>
      <table>
        elements()
      </table>
    </fieldset>
  }*/
  
/*
  define ignore-access-control grouptest(){
    <fieldset class="fieldset_no_legend_ "+attribute("class")
      all attributes except "class">
      <table>
        elements()
      </table>
    </fieldset>
  }
 
 */
 
 