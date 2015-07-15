application test

page root(){ a <p>"test"</p><a>"test"</a> }

template a(){
  <style>
    p {
      text-align: center;
      color: yellow;
    }
  </style>
  
  var x := "color: red;"
  
  <style id="idtest" class="classtest">
    a {
      ~x
    }
  </style>

}

test{
  assert(rendertemplate(a()).contains("color: yellow;"));  
  assert(rendertemplate(a()).contains("color: red;"));  
  assert(rendertemplate(a()).contains("idtest"));  
  assert(rendertemplate(a()).contains("classtest"));  
}
  
  