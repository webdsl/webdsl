application test

page root {}

entity Tmp {}
var tmpid := Tmp{}

test {
  var obj1 := JSONObject("{bool:true,string:'foo',int:42,long:1234567890123456,double:4.6,obj:{bool:false},array:[1,2,3],none:null}");
  checkObject( obj1 );
  var obj2 := JSONObject();
  var obj3 := JSONObject("{}");
  assert( obj2.toString() == obj3.toString() );
  obj2.put( "bool", true );
  obj2.put( "string", "foo" );
  obj2.put( "int", 42 );
  obj2.put( "long", 1234567890123456L );
  obj2.put( "double", Double( 4.6f ) );
  obj2.put( "obj", JSONObject("{bool:false}") );
  obj2.put( "array", JSONArray("[1,2,3]") );
  obj2.put( "none", JSONObject.nullValue() );
  checkObject( obj2 );
  obj3.put( "float", 8.4f );
  assert( obj3.getDouble( "float" ).floatValue() == 8.4f );
  obj3.put( "uuid", tmpid.id );
  assert( obj3.getString( "uuid" ) == tmpid.id.toString() );

  var a1 := JSONArray();
  var a2 := JSONArray("[]");
  assert( a1.toString() == a2.toString() );
  a1.put( true );
  a1.put( "foo" );
  a1.put( 42 );
  a1.put( 1234567890123456L );
  a1.put( Double( 4.6f ) );
  a1.put( JSONObject("{bool:false}") );
  a1.put( JSONArray("[1,2,3,4]") );
  a1.put( JSONObject.nullValue() );
  a1.put( 8.4f );
  a1.put( tmpid.id );
  assert( a1.length() == 10 );
  assert( a1.getBoolean( 0 ) == true );
  assert( a1.getString( 1 ) == "foo" );
  assert( a1.getInt( 2 ) == 42 );
  assert( a1.getLong( 3 ) == 1234567890123456L );
  assert( a1.getDouble( 4 ) == Double( 4.6f ) );
  assert( a1.getJSONObject( 5 ).getBoolean( "bool" ) == false );
  assert( a1.getJSONArray( 6 ).length() == 4 );
  assert( a1.getNullValue( 7 ) == JSONObject.nullValue() );
  assert( a1.getDouble( 8 ) == Double( 8.4f ) );
  assert( a1.getString( 9 ) == tmpid.id.toString() );

  var testnull := JSONObject();
  assert( ! testnull.has( "nbool") );
  testnull.put( "nbool", null as Bool );
  assert( testnull.getBoolean( "nbool" ) == null );
  testnull.put( "nstring", null as String );
  assert( testnull.getString( "nstring" ) == null );
  testnull.put( "nint", null as Int );
  assert( testnull.getString( "nint" ) == null );
  testnull.put( "nlong", null as Long );
  assert( testnull.getLong( "nlong" ) == null );
  testnull.put( "nfloat", null as Float );
  assert( testnull.getDouble( "nfloat" ) == null );
  testnull.put( "nobject", null as JSONObject );
  assert( testnull.getJSONObject( "nobject" ) == null );
  testnull.put( "narray", null as JSONArray );
  assert( testnull.getJSONArray( "narray" ) == null );

  var testnullarray := JSONArray();
  testnullarray.put( null as Bool );
  assert( testnullarray.getBoolean( 0 ) == null );
  testnullarray.put( null as String );
  assert( testnullarray.getString( 1 ) == null );
  testnullarray.put( null as Int );
  assert( testnullarray.getInt( 2 ) == null );
  testnullarray.put( null as Long );
  assert( testnullarray.getLong( 3 ) == null );
  testnullarray.put( null as Float );
  assert( testnullarray.getDouble( 4 ) == null );
  testnullarray.put( null as JSONObject );
  assert( testnullarray.getJSONObject( 5 ) == null );
  testnullarray.put( null as JSONArray );
  assert( testnullarray.getJSONArray( 6 ) == null );
}

function checkObject( obj: JSONObject ){
  assert( obj.has( "bool" ) == true );
  assert( obj.getBoolean( "bool" ) == true );
  assert( obj.getString( "string" ) == "foo" );
  assert( obj.getInt( "int" ) == 42 );
  assert( obj.getLong( "long" ) == 1234567890123456L );
  assert( obj.getDouble( "double" ).floatValue() == 4.6f );
  assert( obj.getJSONObject( "obj" ).getBoolean("bool") == false );
  assert( obj.getJSONArray( "array" ).length() == 3 );
  assert( obj.getNullValue( "none" ) == JSONObject.nullValue() );
}