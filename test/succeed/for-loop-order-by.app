application exampleapp

page root(){}
  
template show(){
  var substract100 := true
  
  for( t: Tag in (from Tag order by num) ){ //this is hql in brackets 
    output( t.num )
  } separated-by{ "-" }
  
  for( t in (from Tag) order by t.converted(substract100)){
  	output( t.num )
  } separated-by{ "," }
}

entity Tag{
  num : Int
  function converted(sub100 : Bool) : Int{
  	return if(sub100) num-100 else num;
  }
}
  
init{
  for( i: Int from 1 to 22 ){
    var t := Tag{ num := i };
    t.save();
  }
}

test{
  assert( rendertemplate( show() ).contains( "1-2-3-4-5-6-7-8-9-10-11-12-13-14-15-16-17-18-19-20-21" ) );
  assert( rendertemplate( show() ).contains( "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21" ) );
}
