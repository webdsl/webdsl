application test

page root(){}
  
test{
  for( i: Int from 1 to 5 ){
    assert( check( i ) == i );
  }
}

function check( i: Int ): Int {
  if( i <= 1 ){
    return 1;
  }
  else if( i <= 2 ){
    return 2;
  }
  else if( i <= 3 ){
    return 3;
  }
  else{
    return 4;
  }
}