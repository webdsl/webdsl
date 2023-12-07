//#4 defined multiple times

application test

page root {
  action a {}
  action a {}
  init {}
  init {}  // allowed
  action b( i: Int ){}
  action b( s: String ){}
}
