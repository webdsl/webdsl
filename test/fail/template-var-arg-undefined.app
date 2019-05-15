//Variable 'e' not defined
//No property title1
//TemplateElements argument 'c.elemz' not defined
//TemplateElements argument 'd.elems' not defined
application test

page root(){}

template tabs(contents : [title: String, elems:TemplateElements]) {
  if(contents.length > 0){
    <ul>
    for(c in contents){
      <li>
        output(c.title)
      </li>
    }
    </ul>

    for( c in contents ){
      <div class="content">
        output(e.title) ":"
        output(c.title1) ":"
        c.elemz
        d.elems
        c.elems  // correct
      </div>
    }
  }
}
