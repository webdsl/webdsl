application test

entity A {
 name :: String
 body :: String
 child -> A
}



page root (){


}


define page testing() {
	var ent : A
	init{ 
		if( findAByName("test").length == 0) {
			ent := A { name := "test"};
		} else {
			ent := findAByName("test")[0];
		}
	}
	output("version: " + ent.version)
	output("created: " + ent.created)
	output("modified: " + ent.modified)	
	form {
	 submit save()[class="saveb"]{"save"}
	 submit modify()[class="modifyb"]{"modify"}

	}
	 
	 action save () {
	 	ent.save(); 
	 }
	 

	 action modify() {
	 	ent.body := "modifiedtest";
	 	return datetest(ent.created.toString(), ent.modified.toString(), ent);
	 }
}
 page datetest( created : String, modified : String, ent : A){
	output("version: " + ent.version)
	output("created: " + ent.created)
	output("modified: " + ent.modified)
	output("createdchanged: " + (created != ent.created.toString()))
	output("modifiedchanged: " + (modified != ent.modified.toString()))
	
	form {
	 submit modify()[class="modifyb"]{"modify"}
	}
	action modify() {
	 	ent.body := "modifiedtest";
	 	return datetest(ent.created.toString(), ent.modified.toString(), ent);
	 }
}

test normalEntitySaveModifyChain {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(testing()));	
	assert(d.getPageSource().contains("version: 0"), "version should be zero when entity is not saved");

	assert(d.getPageSource().contains("created: null"), "created should be null when entity is not saved");
	assert(d.getPageSource().contains("modified: null"), "modified should be null when entity is not saved");
	
	var button := d.findElements(SelectBy.className("saveb"))[0];
    button.click();
	
	assert(d.getPageSource().contains("version: 1"), "version should be one direct after saving an entity");
	assert(!d.getPageSource().contains("created: null"), "created should not be null when entity is not saved");
	assert(!d.getPageSource().contains("modified: null"), "modified should not be null when entity is not saved");
	
	var button1 := d.findElements(SelectBy.className("modifyb"))[0];
    button1.click();
    
	assert(d.getPageSource().contains("version: 2"), "version should be higher after editing entity");
	assert(d.getPageSource().contains("createdchanged: false"), "created should not be changed when entity is changed");
	assert(d.getPageSource().contains("modifiedchanged: true"), "modified should  be changed when entity is changed");
	
	var button2 := d.findElements(SelectBy.className("modifyb"))[0];
    button2.click();
    
    assert(d.getPageSource().contains("version: 2"), "only real modifies should increase the version");
    assert(d.getPageSource().contains("createdchanged: false"), "created should not be changed when entity is not dirty");
	assert(d.getPageSource().contains("modifiedchanged: false"), "modified should not be changed when entity is not dirty");
}
var parent := A{}

define page cascadeTest() {
	var child : A
	
	init{ 
		child := A {}; 
	}
	output("versionp: " + parent.version)
	output("createdp: " + parent.created)
	output("modifiedp: " + parent.modified)
	output("versionc: " + child.version)
	output("createdc: " + child.created)
	output("modifiedc: " + child.modified)
	form {
	  submit save()[class="saveb"]{"save"}
	}
	 
	 action save () {
	 	parent.child := child; 
	 	return datetestCascade(parent.created.toString(), parent.modified.toString());

	 }
}

 page datetestCascade( createdp : String, modifiedp : String){
	output("versionp: " + parent.version)
	output("createdchanged: " + (createdp != parent.created.toString()))
	output("modifiedchanged: " + (modifiedp != parent.modified.toString()))
	output("versionc: " + parent.child.version)
	output("createdc: " + parent.child.created)
	output("modifiedc: " + parent.child.modified)
}

test cascadedSave {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(cascadeTest()));	
	assert(d.getPageSource().contains("versionp: 1"), "version should be one of start global");
	assert(!d.getPageSource().contains("createdp: null"), "global is saved so created should not be null");
	assert(!d.getPageSource().contains("modifiedp: null"), "global is saved so modified should not be null");
	assert(d.getPageSource().contains("versionc: 0"), "version should be zero of non saved object");
	assert(d.getPageSource().contains("createdc: null"), "created should be null of non saved object");
	assert(d.getPageSource().contains("modifiedc: null"), "modified should be null of non saved object");
	
	var button := d.findElements(SelectBy.className("saveb"))[0];
    button.click();
    
	assert(d.getPageSource().contains("versionp: 2"), "version should be changed after object change");
    assert(d.getPageSource().contains("createdchanged: false"), "created should not be changed when entity is changed");
	assert(d.getPageSource().contains("modifiedchanged: true"), "modified should  be changed when entity is changed");
	assert(d.getPageSource().contains("versionc: 1"), "version should be one afer cascaded save");
	assert(!d.getPageSource().contains("createdc: null"), "created should be set after cascaded save");
	assert(!d.getPageSource().contains("modifiedc: null"), "modified should be set after cascaded save");
}
entity B {
 c -> C
}

entity C {
 b -> B (inverse=B.c)	
}

var master := C {}

var slave := B {}

define page inverseTest() {

	output("versionm: " + master.version)
	output("createdm: " + master.created)
	output("modifiedm: " + master.modified)
	output("versions: " + slave.version)
	output("createds: " + slave.created)
	output("modifieds: " + slave.modified)
	form {
	  submit modify()[class="modifyb"]{"modify"}
	}
	
	 action modify () {
	 	master.b := slave; 
	 	return datetestInverse(master.created.toString(), master.modified.toString(), slave.created.toString(), slave.modified.toString());
	 }
}

page datetestInverse( createdm : String, modifiedm : String, createds : String, modifieds : String){
	output("versionm: " + master.version)
	output("createdchangedm: " + (createdm != master.created.toString()))
	output("modifiedchangedm: " + (modifiedm != master.modified.toString()))
	output("versions: " + slave.version)
	output("createdchangeds: " + (createds != slave.created.toString()))
	output("modifiedchangeds: " + (modifieds != slave.modified.toString()))
}

test inverseModify {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(inverseTest()));	
	assert(d.getPageSource().contains("versionm: 1"), "version should be one of start global");
	assert(!d.getPageSource().contains("createdm: null"), "global is saved so created should not be null");
	assert(!d.getPageSource().contains("modifiedm: null"), "global is saved so modified should not be null");
	assert(d.getPageSource().contains("versions: 1"), "version should be one of start global");
	assert(!d.getPageSource().contains("createds: null"), "global is saved so created should not be null");
	assert(!d.getPageSource().contains("modifieds: null"), "global is saved so modified should not be null");
	
	var button := d.findElements(SelectBy.className("modifyb"))[0];
    button.click();

	assert(d.getPageSource().contains("versionm: 2"), "version should be changed after object change");
    assert(d.getPageSource().contains("createdchangedm: false"), "created should not be changed when entity is changed");
	assert(d.getPageSource().contains("modifiedchangedm: true"), "modified should  be changed when entity is changed");
	assert(d.getPageSource().contains("versions: 2"), "version should be changed after object change");
    assert(d.getPageSource().contains("createdchangeds: false"), "created should not be changed when entity is changed");
	assert(d.getPageSource().contains("modifiedchangeds: true"), "modified should  be changed when entity is changed");
}

entity D{
list -> List<E>
}

entity E{
name :: String
}

var listent :=	 D{ list := List<E>()}

define page listTest() {
	output("version: " + listent.version)
	output("created: " + listent.created)
	output("modified: " + listent.modified)
	form {
	 submit modify()[class="modifyb"]{"modify"}
	}
	
	 action modify () {
	 	listent.list.add( E{ name := "test2" });
	 	return datetestList (listent.created.toString(), listent.modified.toString());
	 }
}

page datetestList( created : String, modified : String){
	output("version: " + listent.version)
	output("createdchanged: " + (created != listent.created.toString()))
	output("modifiedchanged: " + (modified != listent.modified.toString()))
}

test listModify {
	var d : WebDriver := getHtmlUnitDriver();
	d.get(navigate(listTest()));	
	assert(d.getPageSource().contains("version: 1"), "version should be one of start global");
	assert(!d.getPageSource().contains("created: null"), "global is saved so created should not be null");
	assert(!d.getPageSource().contains("modified: null"), "global is saved so modified should not be null");
	
	var button := d.findElements(SelectBy.className("modifyb"))[0];
    button.click();

	assert(d.getPageSource().contains("version: 2"), "version should be changed after object change");
    		assert(d.getPageSource().contains("createdchanged: false"), "created should not be changed when entity is changed");
	assert(d.getPageSource().contains("modifiedchanged: true"), "modified should  be changed when entity is changed");
}