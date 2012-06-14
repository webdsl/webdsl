application test

native class org.hibernate.Session as Session {
  clear()
}

native class org.hibernate.SessionFactory as SessionFactory {
  getCurrentSession() : Session
}

native class utils.HibernateUtilConfigured as HibernateUtilConfigured {
  static getSessionFactory() : SessionFactory
}

native class utils.RequestAppender as RequestAppender {
  constructor()
  static getInstance() : RequestAppender
  close()
  addRequest(String)
  getLog(String) : String
  removeRequest(String)
}

native class utils.HibernateLog as HibernateLog {
  constructor()
  tryParse(String, Session) : Bool
  getError() : String
  getSQLCount() : Int
  getEntityCount() : Int
  getDuplicateCount() : Int
  getCollectionCount() : Int
  getEntityCount(String) : Int
  getDuplicateCount(String) : Int
  getCollectionCount(String) : Int
}

native class org.apache.log4j.MDC as MDC {
  static put(String,String)
  static remove(String)
}

function initLog() {
  // Initialize logging
  var reqAppender : RequestAppender := RequestAppender.getInstance();
  var rleId : String := "test";
  MDC.put("request", rleId);
  MDC.put("template", "");
  reqAppender.addRequest(rleId);
}

function getLog() : HibernateLog {
  var reqAppender : RequestAppender := RequestAppender.getInstance();
  var rleId : String := "test";
  var hibernateLog : HibernateLog := HibernateLog();
  var parsed : Bool := hibernateLog.tryParse(reqAppender.getLog(rleId), HibernateUtilConfigured.getSessionFactory().getCurrentSession());
  assert(parsed, "Failed to parse log");
  if(!parsed) {
    log("Exception: " + hibernateLog.getError());
  }
  return hibernateLog;
}

function closeLog() {
  // Cleanup
  var reqAppender : RequestAppender := RequestAppender.getInstance();
  var rleId : String := "test";
  reqAppender.removeRequest(rleId);
  MDC.remove("request");
  MDC.remove("template");
}

function clearSession() {
  HibernateUtilConfigured.getSessionFactory().getCurrentSession().clear();
}

function assertLog(name : String, sql : Int, ent : Int, dup : Int, col : Int) {
  assertLog(getLog(), name, sql, ent, dup, col);
}

function assertLog(hibLog : HibernateLog, name : String, sql : Int, ent : Int, dup : Int, col : Int) {
  assert(hibLog.getSQLCount()==sql, name + " Sql: " + hibLog.getSQLCount() + "!=" + sql);
  assert(hibLog.getEntityCount()==ent, name + " Ent: " + hibLog.getEntityCount() + "!=" + ent);
  assert(hibLog.getDuplicateCount()==dup, name + " Dup: " + hibLog.getDuplicateCount() + "!=" + dup);
  assert(hibLog.getCollectionCount()==col, name + " Col: " + hibLog.getCollectionCount() + "!=" + col);
}

function newTest() {
  initLog();
}

function finalizeTest(name : String, sql : Int, ent : Int, dup : Int, col : Int) {
  finalizeTest(getLog(), name, sql, ent, dup, col);
}

function finalizeTest(hibLog : HibernateLog, name : String, sql : Int, ent : Int, dup : Int, col : Int) {
  assertLog(hibLog, name, sql, ent, dup, col);
  closeLog();
  clearSession();
}

entity RootBase {
  intProp :: Int
  strProp :: String
  boolProp :: Bool
  entProp -> Base
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
    r.intProp := i;
    r.strProp := ("" + i);
    r.boolProp := (i % 2 == 0);
    r.save();
  }
}

define page root() {
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
  assertLogWithEntities(hibLog, "testIntCond()", 2, 0, 0, 0, 8, 8, 4, 4);
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
  assertLogWithEntities(hibLog, "testIntCondCast()", 2, 0, 0, 0, 8, 8, 2, 2);
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
  assertLogWithEntities(hibLog, "testStrCond()", 2, 0, 0, 0, 8, 8, 4, 4);
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
  assertLogWithEntities(hibLog, "testStrCondCast()", 2, 0, 0, 0, 8, 8, 2, 2);
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
  assertLogWithEntities(hibLog, "testBoolCond()", 2, 0, 0, 0, 8, 8, 8, 0);
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
  assertLogWithEntities(hibLog, "testBoolCondCast()", 2, 0, 0, 0, 8, 8, 0, 4);
  closeLog();
}

define templ(r : RootBase) {}

define templ() {
  for(r : RootBase) {
    prefetch-for r {
      entProp default [templ(RootBase)]
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
  assertLogWithEntities(hibLog, "testNoRedef()", 2, 0, 0, 0, 8, 8, 8, 8);
  closeLog();
}

function testWithRedef() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(templWithRedef());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "testWithRedef()", 1, 0, 0, 0, 8, 8, 0, 0);
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
  assertLogWithEntities(hibLog, "testPrefetchChildren()", 3, 0, 0, 0, 8, 8, 8, 24);
  closeLog();
}

function assertLogWithEntities(hibLog : HibernateLog, name : String, sql : Int, ent : Int, dup : Int, col : Int, rootBase : Int, rootSub : Int, base : Int, sub : Int) {
  assertLog(hibLog, name, sql, ent + rootBase + rootSub + base + sub, dup, col);
  assertEntities(hibLog, name, rootBase, rootSub, base, sub);
}

function assertEntities(hibLog : HibernateLog, name : String, rootBase : Int, rootSub : Int, base : Int, sub : Int) {
  assert(hibLog.getEntityCount("RootBase")==rootBase, name + " RootBase: " + hibLog.getEntityCount("RootBase") + "!=" + rootBase);
  assert(hibLog.getEntityCount("RootSub")==rootSub, name + " RootSub: " + hibLog.getEntityCount("RootSub") + "!=" + rootSub);
  assert(hibLog.getEntityCount("Base")==base, name + " Base: " + hibLog.getEntityCount("Base") + "!=" + base);
  assert(hibLog.getEntityCount("Sub")==sub, name + " Sub: " + hibLog.getEntityCount("Sub") + "!=" + sub);
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
}
