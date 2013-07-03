//error: Principal credential 'J4L' is not a property of entity 'xHi69N4'.
//error: Only one access control principal can be defined.
//error: Entity name: "xHi69N4" should start with a Capital
//#3 error: Entity may not inherit from itself.
//error: Entity 'S_5sqX6W_S1' does not exist, and cannot be used as principal for access control.
//error: Principal credential 'S_gGS_2Mvn5' is not a property of entity 'S_5sqX6W_S1'.
//error: Only one access control principal can be defined.
//error: Super entity Q_ for NV_P3__0_GU does not exist.

application v04_1C2_81G

  // http://yellowgrass.org/issue/WebDSL/732 and http://yellowgrass.org/issue/WebDSL/669
  principal is xHi69N4 with credentials J4L
  entity xHi69N4 : PC7 { }
  entity PC7 : xHi69N4 { }
  
  // http://yellowgrass.org/issue/WebDSL/733
  principal is S_5sqX6W_S1 with credentials S_gGS_2Mvn5
  native class S_5sqX6W_S1 : S_5sqX6W_S1 {  }
  
  // http://yellowgrass.org/issue/WebDSL/668
  entity NV_P3__0_GU : Q_ { }
  native class Q_ : Q_ { }
  
  page root(){}