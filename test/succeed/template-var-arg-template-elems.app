application test

page root(){
  testtemplate
}

entity Tmp{
  name : String
  i : Int
}

init{
  Tmp{ name := "tmp1name" i := 101 }.save();
  Tmp{ name := "tmp2name" i := 202 }.save();
}

template testtemplate(){
  var tmpstring := "test"
  tabs(
    [
      ( "first",
        { div{ "content" } }
      ),
      for(t : Tmp){
        ( t.name,
          { output(tmpstring) output(t.i) }
        )
      }
    ]
  )
}

template tabs(contents : [title: String, elems:TemplateElements]) {
  if(contents.length > 0){
    <ul>
    for(c in contents){
      <li>
        output(c.title)
      </li>
    }
    </ul>

    for(c in contents){
      <div class="content">
        output(c.title) ":"
        c.elems
      </div>
    }
  }
}

test{
  log(rendertemplate(testtemplate()));
  assert(rendertemplate(testtemplate()) == "<ul><li>first</li><li>tmp1name</li><li>tmp2name</li></ul><div class=\"content\">first:<div>content</div></div><div class=\"content\">tmp1name:test101</div><div class=\"content\">tmp2name:test202</div>");
}
