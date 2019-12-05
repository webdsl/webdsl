application test

page root(){
  placeholder "checklist" checkListEdit(a1)
}

page test2(){
  placeholder "checklist" checkListEdit(b1)
}

var a1 := Assignment{ checkList := CheckList{} }
var b1 := Assignment{ checkList := CheckList{} }

entity Assignment{
  checkList : CheckList
}

entity CheckList{
  items : [CheckListItem]
  
  function addItem(){
    items.add(CheckListItem{});
    // without flush or explicit save, the template id of the new item was used as if transient in the for loop,
    // because the choice for persisted tempate id checks for version > 0, which gets set to 1 in flush handler.
    // in this case the initial ajax render would use the non-persisted template id, and when submitting
    // it would check for the persisted template id, so the input values of the last added item were ignored.
    //
    // the reason for using entity ids if persisted is to protect from accidental overwrite of different entity, which
    // would happen when another user has changed the list and a simple template id is used, e.g. based on for loop count
  }
  function addAllItems(){
    items.addAll([CheckListItem{},CheckListItem{}]);
  }
}

entity CheckListItem{
  weight : Float
}

ajax template checkListEdit(assign: Assignment){
  var list : CheckList := assign.checkList
  var count := 0
  action addItem(){
    list.addItem();
    replace("checklist", checkListEdit(assign));
  }
  action addAllItems(){
    list.addAllItems();
    replace("checklist", checkListEdit(assign));
  }
  form{
    for(item: CheckListItem in list.items){
      input(item.weight)[class="input"]
    }
    submitlink addItem(){ "Save and Add Item" }
    submitlink addAllItems(){ "Save and AddAll Items" }
  }
}

test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  d.getSubmit().click();
  d.findElements(SelectBy.className("input"))[0].sendKeys("678");  
  d.getSubmit().click();
  assert(d.getPageSource().contains("678")); // the bug caused this input value to disappear
  
  d.get(navigate(test2()));
  d.getSubmits()[1].click();
  d.findElements(SelectBy.className("input"))[0].sendKeys("777");
  d.findElements(SelectBy.className("input"))[0].sendKeys("888");
  d.getSubmits()[1].click();
  assert(d.getPageSource().contains("777"));
  assert(d.getPageSource().contains("888"));
}
   