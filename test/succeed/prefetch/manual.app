application test

imports module/logutils

entity RootBase {
  intProp :: Int
  strProp :: String
  boolProp :: Bool
  entProp -> Base
  intLst -> List<Elem>
  
  function doNothing() {}
}

entity RootSub : RootBase {
  subInt :: Int
  subStr :: String
  subBool :: Bool
  subProp -> Base
}

entity Base {
  sub -> Sub
}

entity Sub : Base {
}

entity Elem {
  intProp :: Int
}

init{
  for(i : Int from 0 to 16) {
    var r : RootBase;
    if(i % 4 == 0) { // 0 4 8 12
      r := RootBase { entProp := Base{ sub := Sub{} } };
    } else { if(i % 4 == 1) { // 1 5 9 13
      r := RootBase { entProp := Sub{ sub := Sub{} } };
    } else { if(i % 4 == 2) { // 2 6 10 14
      r := RootSub { entProp := Base{ sub := Sub{} } subProp := Sub{} subInt := i subStr := ("" + i) subBool := (i % 2 == 0) };
    } else { if(i % 4 == 3) { // 3 7 11 15
      r := RootSub { entProp := Sub{ sub := Sub{} } subProp := Base{} subInt := i subStr := ("" + i) subBool := (i % 2 == 0) };
    } } } }
    r.intLst.add(Elem{intProp := 1});
    r.intLst.add(Elem{intProp := 2});
    r.intLst.add(Elem{intProp := 3});
    r.intLst.add(Elem{intProp := 4});
    r.intLst.add(Elem{intProp := 5});
    r.intLst.add(Elem{intProp := 6});
    r.intProp := i;
    r.strProp := ("" + i);
    r.boolProp := (i % 2 == 0);
    r.save();
  }
}

page root(){
  templ(RootBase{})
  templ()
  templWithRedef()
}

function testIntCond() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      entProp if(.intProp>=8)
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testIntCond()", 2, 0, 0, 0, 8, 8, 4, 4, 0);
  closeLog();
}

function testIntCondCast() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      RootSub.subProp if(RootSub.subInt>=8)
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testIntCondCast()", 2, 0, 0, 0, 8, 8, 2, 2, 0);
  closeLog();
}

function testStrCond() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      entProp if(.strProp=="8" || .strProp=="9" || .strProp=="10" || .strProp=="11" || .strProp=="12" || .strProp=="13" || .strProp=="14" || .strProp=="15")
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testStrCond()", 2, 0, 0, 0, 8, 8, 4, 4, 0);
  closeLog();
}

function testStrCondCast() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      RootSub.subProp if(RootSub.subStr=="8" || RootSub.subStr=="9" || RootSub.subStr=="10" || RootSub.subStr=="11" || RootSub.subStr=="12" || RootSub.subStr=="13" || RootSub.subStr=="14" || RootSub.subStr=="15")
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testStrCondCast()", 2, 0, 0, 0, 8, 8, 2, 2, 0);
  closeLog();
}

function testBoolCond() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      entProp if(.boolProp)
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testBoolCond()", 2, 0, 0, 0, 8, 8, 8, 0, 0);
  closeLog();
}

function testBoolCondCast() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      RootSub.subProp if(RootSub.subBool)
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testBoolCondCast()", 2, 0, 0, 0, 8, 8, 0, 4, 0);
  closeLog();
}

define templ(r : RootBase) {}

define templ() {
  for(r : RootBase) {
    prefetch-for r {
      entProp templates [ templ(this) ]
    }
    ""
  }  
}

define templWithRedef() {
  templ()
  define templ(r : RootBase) {}
}

function testNoRedef() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(templ());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testNoRedef()", 2, 0, 0, 0, 8, 8, 8, 8, 0);
  closeLog();
}

function testWithRedef() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(templWithRedef());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testWithRedef()", 2, 0, 0, 0, 8, 8, 8, 8, 0);
  closeLog();
}

function testPrefetchChildren() {
  clearSession();
  initLog();

  for(r : RootBase) {
    prefetch-for r {
      entProp {
        sub
      }
    }
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testPrefetchChildren()", 3, 0, 0, 0, 8, 8, 8, 24, 0);
  closeLog();
}

function testTwoManualFilters() {
  clearSession();
  initLog();

  for(r : RootBase) {
    var sum1 : Int := 0;
    var sum2 : Int := 0;
    prefetch-for r {
      intLst where(.intProp <= 2 || .intProp > 4)
    }
    for(e1 : Elem in r.intLst) {
      prefetch-for e1 where(.intProp <= 2) {}
      sum1 := sum1 + e1.intProp;
    }
    for(e2 : Elem in r.intLst) {
      prefetch-for e2 where(.intProp > 4) {}
      sum2 := sum2 + e2.intProp;
    }
    // All fetched elements are summed up, because there is no where clause on the for-loops
    // The elements 3 and 4 are excluded, but 1, 2, 5 and 6 (the sum is 14) are included 
    assert(sum1==14);
    assert(sum2==14);
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testTwoManualFilters()", 2, 0, 0, 16, 8, 8, 0, 0, 64);
  closeLog();
}

function testNoEmptyBatch() {
  clearSession();
  initLog();

  var roots : List<RootBase> := from RootBase;
  for(r1 : RootBase in roots) {
    prefetch-for r1 { entProp }
    r1.doNothing();
  }
  for(r2 : RootBase in roots) {
    prefetch-for r2 {
      entProp no-empty-batch {
        sub
      }
    }
    r2.doNothing();
  }
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testNoEmptyBatch()", 2, 0, 0, 0, 8, 8, 8, 8, 0);
  closeLog();
}

function assertLogWithEntities(hibLog : HibernateLog, name : String, sql : Int, ent : Int, dup : Int, col : Int, rootBase : Int, rootSub : Int, base : Int, sub : Int, elem : Int) {
  assertLog(hibLog, name, sql, ent + rootBase + rootSub + base + sub + elem, dup, col);
  assertEntities(hibLog, name, rootBase, rootSub, base, sub, elem);
}

function assertEntities(hibLog : HibernateLog, name : String, rootBase : Int, rootSub : Int, base : Int, sub : Int, elem : Int) {
  assert(hibLog.getEntityCount("RootBase")==rootBase, name + " RootBase: " + hibLog.getEntityCount("RootBase") + "!=" + rootBase);
  assert(hibLog.getEntityCount("RootSub")==rootSub, name + " RootSub: " + hibLog.getEntityCount("RootSub") + "!=" + rootSub);
  assert(hibLog.getEntityCount("Base")==base, name + " Base: " + hibLog.getEntityCount("Base") + "!=" + base);
  assert(hibLog.getEntityCount("Sub")==sub, name + " Sub: " + hibLog.getEntityCount("Sub") + "!=" + sub);
  assert(hibLog.getEntityCount("Elem")==elem, name + " Elem: " + hibLog.getEntityCount("Elem") + "!=" + elem);
}

test {
  testIntCond();
  testIntCondCast();
  testStrCond();
  testStrCondCast();
  testBoolCond();
  testBoolCondCast();
  testNoRedef();
  testWithRedef();
  testPrefetchChildren();
  testTwoManualFilters();
  testNoEmptyBatch();
}
