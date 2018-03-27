//test for issue : http://yellowgrass.org/issue/WebDSL/606
application test

entity A {
	string :: String
	email  :: Email
	secret :: Secret
	text :: Text
	wikitext :: WikiText
	url :: URL
	
	bool :: Bool
	
	int :: Int
	float :: Float
	long :: Long
	
	date ::Date
	datetime :: DateTime
	time :: Time
	
	image :: Image
	file  :: File
	
	b -> B (inverse=B.a)
	listb -> List<B> (inverse=B.a2)
	setb -> Set<B> (inverse=B.a3)
	
}

entity B {
	name :: String
	a -> A
	a2 -> A
	a3 -> A
}

var one := A { 
				string := "test",
			   	bool := true,
			   	email := "example@example.org",
			   	secret := "secret",
			   	text := "een lang verhaal is altijd leuk",
			   	wikitext := "eeen lang opgemaakt verhaal",
			   	url := "http://www.yellowgrass.org",
			   	int := 0,
			   	float := 1.123,
			   	long := 111111111111111L,
			   	datetime := now(),
			   	date := now(),
			   	time := now()
			 }
	var b2 := B{name := "2"}
	var b3 := B{name := "3"}
	var b4 := B{name := "4"}
	var b5 := B{name := "5"}

init{
	one.b := b2;
	one.listb := [b2];
	one.setb := {b2};
	
}

page cleanup(){
	init{
		one.string := "test";
		one.bool := true;
		one.email := "example@example.org";
		one.secret := "secret";
		one.text := "een lang verhaal is altijd leuk";
		one.wikitext := "eeen lang opgemaakt verhaal";
		one.url := "http://www.yellowgrass.org";
		one.int := 0;
		one.float := 1.123;
		one.long := 111111111111111L;
		one.datetime := now();
		one.date := now();
		one.time := now();
		one.b := b2;
		one.listb := [b2];
		one.setb := {b2};
	}
	
}

define page root() {
	action changeString(){
		return changeString(one, one.version);
	}
	action changeBool(){
		return changeBool(one, one.version);
	}
	action changeEmail(){
		return changeEmail(one, one.version);
	}
	action changeSecret(){
		return changeSecret(one, one.version);
	}
	action changeText(){
		return changeText(one, one.version);
	}
	action changeWikiText(){
		return changeWikiText(one, one.version);
	}
	action changeURL(){
		return changeURL(one, one.version);
	}
	action changeInt(){
		return changeInt(one, one.version);	
	}
	action changeFloat(){
		return changeFloat(one, one.version);	
	}
	action changeLong(){
		return changeLong(one, one.version);	
	}
	action changeDateTime(){
		return changeDateTime(one, one.version);	
	}
	action changeTime(){
		return changeTime(one, one.version);	
	}
	action changeDate(){
		return changeDate(one, one.version);	
	}
	action changeImage(){
		return changeImage(one, one.version);	
	}
	action changeFile(){
		return changeFile(one, one.version);	
	}
	action changeB(){
		return changeB(one, one.version, b2.version, b3.version, b4.version, b5.version);	
	}
	action changeListB(){
		return changeListB(one, one.version, b2.version, b3.version, b4.version, b5.version);	
	}
	action changeSetB(){
		return changeSetB(one, one.version, b2.version, b3.version, b4.version, b5.version);	
	}
	action changeAll(){
		return changeAll(one, one.version);	
	}
	form{
		submit changeString() [class="testone"] {"changeString"}
		submit changeBool() [class="testtwo"] {"changeBool"}
		submit changeEmail() [class="testthree"] {"changeEmail"}
		submit changeSecret() [class="testfive"] {"changeSecret"}
		submit changeText() [class="testfour"] {"changeText"}
		submit changeWikiText() [class="testsix"] {"changeWikiText"}
		submit changeWikiText() [class="testseven"] {"changeURL"}
		submit changeInt() [class="test8"] {"changeInt"}
		submit changeFloat() [class="test9"] {"changeFloat"}
		submit changeLong() [class="test10"] {"changeLong"}
		submit changeDateTime() [class="test11"] {"changeDateTime"}
		submit changeDate() [class="test12"] {"changeDate"}
		submit changeTime() [class="test13"] {"changeTime"}
		submit changeImage() [class="test14"] {"changeImage"}
		submit changeFile() [class="test15"] {"changeFile"}
		submit changeB() [class="test16"] {"changeB"}
		submit changeListB() [class="test17"] {"changeListB"}
		submit changeSetB() [class="test18"] {"changeSetB"}
		submit changeAll() [class="test19"] {"changeAll"}

		
	}
}

define page showVersionChanged(ent : A, version : Int){
	par { output("versionChanged: " + (ent.version != version).toString()) }
	par { output("versionDiff: " + (ent.version - version).toString()) }
}

define page showVersionChangedAll(ent : A, version : Int, versionb2 : Int, versionb3 : Int, versionb4 : Int, versionb5 : Int){
	par { output("versionChanged: " + (ent.version != version).toString()) }
	par { output("versionDiff: " + (ent.version - version).toString()) }
	par {output(ent.version)}
	par {output(version)}
	par { output("versionChangedb2: " + (b2.version != versionb2).toString()) }
	par { output("versionDiffb2: " + (b2.version - versionb2).toString()) }
	par {output(b2.version)}
	par {output(versionb2)}
	par { output("versionChangedb3: " + (b3.version != versionb3).toString()) }
	par { output("versionDiffb3: " + (b3.version - versionb3).toString()) }
	par {output(b3.version)}
	par {output(versionb3)}
	par { output("versionChangedb4: " + (b4.version != versionb4).toString()) }
	par { output("versionDiffb4: " + (b4.version - versionb4).toString()) }
	par {output(b4.version)}
	par {output(versionb4)}
	par { output("versionChangedb5: " + (b5.version != versionb5).toString()) }
	par { output("versionDiffb5: " + (b5.version - versionb5).toString()) }
	par {output(b5.version)}
	par {output(versionb5)}
}

define page changeString(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.string)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeBool(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.bool)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeEmail(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.email)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeText(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.text)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeWikiText(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.wikitext)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeSecret(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.secret)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeURL(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.url)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeInt(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.int)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeFloat(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.float)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeLong(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.long)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

	define page changeDateTime(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.datetime)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeDate(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.date)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeTime(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.time)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeImage(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.image)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeFile(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.file)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeB(ent : A, version : Int, versionb2 : Int, versionb3 : Int, versionb4 : Int, versionb5 : Int) {
	action save (){
		return showVersionChangedAll(ent, version, versionb2, versionb3, versionb4, versionb5);
	}
	form {
		input(ent.b)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}
define page changeListB(ent : A, version : Int, versionb2 : Int, versionb3 : Int, versionb4 : Int, versionb5 : Int) {
	action save (){
		return showVersionChangedAll(ent, version, versionb2, versionb3, versionb4, versionb5);
	}
	form {
		input(ent.listb)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeSetB(ent : A, version : Int, versionb2 : Int, versionb3 : Int, versionb4 : Int, versionb5 : Int) {
	action save (){
		return showVersionChangedAll(ent, version, versionb2, versionb3, versionb4, versionb5);
	}
	form {
		input(ent.setb)[class:="input-trigger"]
		submit save()[class="saveb"] { "save" }
	}
}

define page changeAll(ent : A, version : Int) {
	action save (){
		return showVersionChanged(ent, version);
	}
	form {
		input(ent.string)[class:="input1"]
		input(ent.email)[class:="input2"]
		input(ent.secret)[class:="input3"]
		input(ent.text)[class:="input4"]
		input(ent.wikitext)[class:="input5"]
		input(ent.url)[class:="input6"]
		input(ent.bool)[class:="input7"]
		input(ent.int)[class:="input8"]
		input(ent.float)[class:="input9"]
		input(ent.long)[class:="input10"]
		input(ent.date)[class:="input11"]
		input(ent.datetime)[class:="input12"]
		input(ent.time)[class:="input13"]
		input(ent.image)[class:="input14"]
		input(ent.file)[class:="input15"]
		input(ent.b)[class:="input16"]
		input(ent.listb)[class:="input17"]
		input(ent.setb)[class:="input18"]

		submit save()[class="saveb"] { "save" }
	}
}

function cleanup(){
    getHtmlUnitDriver().get(navigate(cleanup()));
}

test stringInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testone"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testone"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.sendKeys("test2");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  

    cleanup();
}
test emailInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testthree"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testthree"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.clear();
    input.sendKeys("example2@test.com");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}
test textInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testfour"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testfour"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.sendKeys("het is maar wat je wilt lalalal");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}
test wikiTextInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testsix"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testsix"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.sendKeys("het is maar wat je wilt lalalal");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}
test secretInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testfive"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testfive"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.sendKeys("wachtwoord");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}
test URLInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testseven"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testseven"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.sendKeys("http://example.org");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  

    cleanup();
}
test boolInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("testtwo"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("testtwo"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.click();
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  

    cleanup();
}
test IntInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test8"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test8"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.sendKeys("1");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}
test LongInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test10"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test10"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.clear();
    input.sendKeys("999999999999");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  

    cleanup();
}
test FLoatInput {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test9"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test9"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    input.clear();
    input.sendKeys("9.876");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  

    cleanup();
}

test DateTimeInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test11"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
	
	// 2 times because first time it cuts of the nanosecconds
	d.get(navigate(root()));	
	
	var button11 := d.findElements(SelectBy.className("test11"))[0];
    button11.click();
    
    var button22 := d.findElements(SelectBy.className("saveb"))[0];
    button22.click();
        
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");

	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test11"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.cssSelector(".input-trigger:not([type='hidden'])"))[0];
    input.clear();
    input.sendKeys("08/10/2012 3:28u'\ue007'"); //ue007 is the return key
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  

    cleanup();
}

test DateInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test12"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
   
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test12"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.cssSelector(".input-trigger:not([type='hidden'])"))[0];
    input.clear();
    input.sendKeys("06/10/2012u'\ue007'"); //ue007 is the return key
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}

test TimeInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test13"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    	   
    // 2 times because first time it cuts of the nanosecconds
	d.get(navigate(root()));	
	
	var button11 := d.findElements(SelectBy.className("test13"))[0];
    button11.click();
    
    var button22 := d.findElements(SelectBy.className("saveb"))[0];
    button22.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test13"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.cssSelector(".input-trigger:not([type='hidden'])"))[0];
    input.clear();
    input.sendKeys("3:28u'\ue007'"); //ue007 is the return key
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0]; 
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	
    cleanup();
}

test ImageInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test14"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
	
    cleanup();
}

test FileInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test15"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");

    cleanup();
}

test EntityInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test16"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb2: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb3: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb4: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb5: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));	
	var button3 := d.findElements(SelectBy.className("test16"))[0];
    button3.click();
    
    var input := d.findElements(SelectBy.className("input-trigger"))[0]; 
    log(d.findElements(SelectBy.className("input-trigger")).length);
    input.click();
    input.sendKeys("3");
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");
    assert(d.getPageSource().contains("versionChangedb4: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb5: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb2: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiffb2: 1"), "version should only increase by 1 after change");
	assert(d.getPageSource().contains("versionChangedb3: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiffb3: 1"), "version should only increase by 1 after change");

    cleanup();
}

test EntityListInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test17"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb2: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb3: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb4: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb5: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));
	var button3 := d.findElements(SelectBy.className("test17"))[0];
    button3.click();

    var input := d.findElements(SelectBy.tagName("select"))[0]; 

    input.click();
    input.sendKeys("3");
    
    var button5 := d.findElements(SelectBy.tagName("input"))[8]; 
    button5.click();
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	//setting list/set with inverse will trigger all the elements to update
	//see: http://yellowgrass.org/issue/WebDSL/610
	//assert(d.getPageSource().contains("versionChangedb2: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb3: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiffb3: 1"), "version should only increase by 1 after change");  
    assert(d.getPageSource().contains("versionChangedb4: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb5: false"), "version should not be altered if property is not changed");
	
    cleanup();
}

test EntitySetInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test18"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb2: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb3: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb4: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb5: false"), "version should not be altered if property is not changed");
	
	d.get(navigate(root()));
	var button3 := d.findElements(SelectBy.className("test18"))[0];
    button3.click();
    
    var checkbox :WebElement := d.findElements(SelectBy.className("checkbox-set"))[0].findElements(SelectBy.className("checkbox-set-element"))[2].findElements(SelectBy.tagName("input"))[1]; 
    checkbox.click();
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
    
    assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiff: 1"), "version should only increase by 1 after change");  
	//setting list/set with inverse will trigger all the elements to update 
	//see: http://yellowgrass.org/issue/WebDSL/610
	//assert(d.getPageSource().contains("versionChangedb2: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb3: true"), "version should increase after change");
	assert(d.getPageSource().contains("versionDiffb3: 1"), "version should only increase by 1 after change");  
    assert(d.getPageSource().contains("versionChangedb4: false"), "version should not be altered if property is not changed");
    assert(d.getPageSource().contains("versionChangedb5: false"), "version should not be altered if property is not changed");

    cleanup();

}

test allInput {
	var d : WebDriver := getFirefoxDriver();
	d.get(navigate(root()));	
	
	var button := d.findElements(SelectBy.className("test19"))[0];
    button.click();
    
    var button2 := d.findElements(SelectBy.className("saveb"))[0];
    button2.click();
    
	//second time to cut of the nanoseconds
	d.get(navigate(root()));	
	
	var button11 := d.findElements(SelectBy.className("test19"))[0];
    button11.click();
    
    var button22 := d.findElements(SelectBy.className("saveb"))[0];
    button22.click();
    
    assert(d.getPageSource().contains("versionChanged: false"), "version should not be altered if property is not changed");


	d.get(navigate(root()));
	var button3 := d.findElements(SelectBy.className("test19"))[0];
    button3.click();

    var input := d.findElements(SelectBy.className("input1"))[0]; 
	input.sendKeys("test2");
	
	input := d.findElements(SelectBy.className("input2"))[0]; 
	input.clear();
	input.sendKeys("a@b.com");
	
	input := d.findElements(SelectBy.className("input3"))[0]; 
	input.sendKeys("nogiets");
	
	input := d.findElements(SelectBy.className("input4"))[0]; 
	input.sendKeys("een verhaal");
	
	input := d.findElements(SelectBy.className("input5"))[0]; 
	input.sendKeys("nog een mooi een verhaal");
	
	input := d.findElements(SelectBy.className("input6"))[0]; 
	input.clear();
	input.sendKeys("http://webdsl.org");
		
	input := d.findElements(SelectBy.className("input7"))[0]; 
	input.click();
	
	input := d.findElements(SelectBy.className("input8"))[0]; 
	input.clear();
	input.sendKeys("88");
	
	input := d.findElements(SelectBy.className("input9"))[0]; 
	input.clear();
	input.sendKeys("8.8");
	
	input := d.findElements(SelectBy.className("input10"))[0]; 
	input.clear();
	input.sendKeys("882332342");
	
	
	input := d.findElements(SelectBy.cssSelector(".input11:not([type='hidden'])"))[0]; 
	input.clear();
	input.sendKeys("03/10/2012u'\ue007'"); //ue007 is the return key
	
	input := d.findElements(SelectBy.cssSelector(".input12:not([type='hidden'])"))[0]; 
	input.clear();	
	input.sendKeys("03/10/2012 3:28u'\ue007'"); //ue007 is the return key
	
	input := d.findElements(SelectBy.cssSelector(".input13:not([type='hidden'])"))[0]; 
	input.clear();
	input.sendKeys("3:28u'\ue007'"); //ue007 is the return key
	
	input := d.findElements(SelectBy.tagName("select"))[1]; 
    input.click();
    input.sendKeys("3");
    
    var button5 := d.findElements(SelectBy.tagName("input"))[19]; 
    button5.click();
	
	input := d.findElements(SelectBy.className("input16"))[0]; 
    input.click();
    input.sendKeys("4");
    
    var checkbox :WebElement := d.findElements(SelectBy.className("checkbox-set"))[0].findElements(SelectBy.className("checkbox-set-element"))[2].findElements(SelectBy.tagName("input"))[1]; 
    checkbox.click();
    
    var button4 := d.findElements(SelectBy.className("saveb"))[0];
    button4.click();
        
	assert(d.getPageSource().contains("versionChanged: true"), "version should increase after change");

    cleanup();
}