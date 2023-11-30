application test

entity Link {
  url : URL
}

var globalLink := Link { url := "http://webdsl.org" }

page root {

  ~globalLink.url

  navigate testpage( 45, "bla", globalLink ){ "link to testpage" }

  navigatebutton( testpage( 45, "bla", globalLink ), "link to testpage" )

  form {
    input( globalLink.url )
    submit save { "save" }
  }
  form {
    input( globalLink.url )
    submit save { "save" }
  }
  action save {
    globalLink.save();
  }

  form {
    submit save2 { "test action return" }
  }
  action save2 {
    return testpage( 43, "bla1", globalLink );
  }

  navigate home2( "bla2", globalLink, 42 ){ "test redirect" }
  navigate root { "root" }
  navigate testpagenoarg { "testpagenoarg" }

}

page testpagenoarg {

}

page testpage( i: Int, s: String, li: Link ){
  ~i
  ~s
  ~li.url
}

page home2( s: String, li: Link, i: Int ){
  init {
    goto testpage( i, s, li );
  }
}

var u1 := User{ name := "testuser" }

page root2 {
  navigate test( u1, "" ){ "test" }
  navigate test1( u1, "", 0 ){ "test1" }
  navigate test2( 0, "", u1 ){ "test2" }
  navigate test3( 0, u1, "" ){ "test3" }
  navigate test4( 0, u1, "", 0.0 ){ "test4" }
  navigate root { "root" }
  navigate with-dash { "test5" }
  navigate with-dash { "test6" }
}

entity User {
  name : String
}

page test( u: User, s: String ){
  ~u.name
  ~s
}

page test1( u: User, s: String, i: Int ){
  ~u.name
  ~s
  ~i
}

page test2( i: Int, s: String, u: User ){
  ~u.name
  ~s
  ~i
}

page test3( i: Int, u: User, s: String ){
  ~u.name
  ~s
  ~i
}

page test4( i: Int, u: User, s: String, f: Float ){
  ~u.name
  ~s
  ~i
  ~f
}

override page pagenotfound {
 "PAGE NOT FOUND :/"
}

page with-dash {}
