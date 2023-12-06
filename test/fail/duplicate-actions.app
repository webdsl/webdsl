//#4 defined multiple times
//#2 block per page or template

application test

page root {
  action a {}
  action a {}
  init {}
  init {}
  action b( i: Int ){}
  action b( s: String ){}
}
