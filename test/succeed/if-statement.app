application test

page root(){}

test{
  for( i: Int from 1 to 5 ){
    assert( check1( i ) == i );
  }
  for( i: Int from 1 to 4 ){
    assert( check2( i ) == i );
  }
  for( i: Int from 1 to 5 ){
    assert( rendertemplate(check1( i )) == ""+i );
  }
  for( i: Int from 1 to 4 ){
    assert( rendertemplate(check2( i )) == ""+i );
  }
}

function check1( i: Int ): Int {
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

function check2( i: Int ): Int {
  if( i <= 1 ){
    return 1;
  }
  else if( i <= 2 ){
    return 2;
  }
  return 3;
}

template check1( i: Int ) {
  if( i <= 1 ){
    "1"
  }
  else if( i <= 2 ){
    "2"
  }
  else if( i <= 3 ){
    "3"
  }
  else{
    "4"
  }
}

template check2( i: Int ) {
  if( i <= 1 ){
    "1"
  }
  else if( i <= 2 ){
    "2"
  }
  if( i == 3 ){
    "3"
  }
}
