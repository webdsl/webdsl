application exampleapp

page root(){}
  
template show(){
  var num100 := Tag{ num := 100 }
  for( t: Tag in (from Tag order by num) ){ //this is hql in brackets 
    output( t.num )
  } separated-by{ "-" }
  
  for( t in (from Tag) order by t.sub(num100)){
  	output( t.num )
  } separated-by{ "," }
}


entity Tag{
  num : Int
  function sub(sub : Tag) : Int{
  	return num-sub.num;
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

  // test static method call in order by
  assert( [ x | x in [5,3,0,2,1,4] order by TestStatic.get(x) ] == [0,1,2,3,4,5] );
  var list := List<Int>();
  for( i in [8,2,6,4] order by TestStatic.get(i) ){
    list.add( i );
  }
  assert( list == [2,4,6,8] );
}

entity TestStatic {
  static function get( j: Int ): Int {
    return j;
  }
}