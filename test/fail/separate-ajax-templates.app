// Ajax template with signature a() not defined
// Template with signature b() not defined
// Template with signature b() not defined

application testapp

page root(){
  placeholder p1 a()   // error
  placeholder p2 b()  
  a
  b                    // error
  placeholder p3{ a }
  placeholder p4{ b }  // error
}

template a(){}
ajax template b(){}