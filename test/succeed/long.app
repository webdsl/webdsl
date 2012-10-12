// issue : http://yellowgrass.org/issue/WebDSL/612
application test

  define page root() {

  }

  test equality{ 
    assert(1 == 1);
   	assert(1L == 1L);
  	assert(1L == 1);    
  	assert(1 == 1L);
}