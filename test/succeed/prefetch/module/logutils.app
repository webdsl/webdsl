module logutils

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
  getEntities() : Set<String>
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