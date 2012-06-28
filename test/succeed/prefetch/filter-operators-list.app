application test

imports module/logutils

// This test is the same as filter-operators-set.app, but using a List instead of a Set.
// As a result no order by expression is provided for the elements of the list, because they should already be sorted.

entity Ent {
  seq :: Int
  col -> List<Elem>
}

entity Elem {
  seq :: Int
  owner :: Int
  next -> Elem
  prev -> Elem (inverse = Elem.next)
}

function createElem(seq : Int, owner : Int, prev : Elem) : Elem {
  var newElem : Elem := Elem{};
  newElem.seq := seq;
  newElem.owner := owner;
  newElem.prev := prev;
  newElem.save();
  return newElem;
}

init {
  for(i : Int from 0 to 3) {
    var e : Ent := Ent{ seq := i };
    var prev : Elem := null;
    for(j : Int from 0 to 10) {
      prev := createElem(j, i, prev);
      e.col.add( prev );
    }
    e.save();
  }
}

define page root() {
  navigate pageFilterNotOr()               { "filterNotOr()" } <br />
  navigate pageFilterEq()                  { "filterEq()" } <br />
  navigate pageFilterNotEq()               { "filterNotEq()" } <br />
  navigate pageFilterIsNull()              { "filterIsNull()" } <br />
  navigate pageNoFilterIsNull()            { "noFilterIsNull()" } <br />
  navigate pageFilterIsNotNull()           { "filterIsNotNull()" } <br />
  navigate pageNoFilterIsNotNull()         { "noFilterIsNotNull()" } <br />
  navigate pageFilterSmallerThan()         { "filterSmallerThan()" } <br />
  navigate pageFilterSmallerThanOrEqual()  { "filterSmallerThanOrEqual()" } <br />
  navigate pageFilterLargerThan()          { "filterLargerThan()" } <br />
  navigate pageFilterLargerThanOrEqual()   { "filterLargerThanOrEqual()" }
}

define output(e : Ent) {
  output(e.seq)
}

define output(e : Elem) {
  "e" output(e.owner) "_" output(e.seq)
}

function filterNotOr() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterNotOr());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterNotOr()", 2, 0, 0, 3, 3, 3);
  assert(tmp=="0e0_5#1e1_5#2e2_5");
  closeLog();
}

define filterNotOr() {
  for(ent : Ent order by ent.seq) {
    for(elemNotOr : Elem in ent.col where !(elemNotOr.seq < 5 || elemNotOr.seq > 5)) {
      output(ent) output(elemNotOr)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterAnd() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterAnd());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterAnd()", 2, 0, 0, 3, 3, 27);
  assert(tmp=="0e0_0|0e0_1|0e0_2|0e0_3|0e0_4|0e0_6|0e0_7|0e0_8|0e0_9#1e1_0|1e1_1|1e1_2|1e1_3|1e1_4|1e1_6|1e1_7|1e1_8|1e1_9#2e2_0|2e2_1|2e2_2|2e2_3|2e2_4|2e2_6|2e2_7|2e2_8|2e2_9");
  closeLog();
}

define filterAnd() {
  for(ent : Ent order by ent.seq) {
    for(elemAnd : Elem in ent.col where elemAnd.seq < 5 && elemAnd.seq > 5) {
      output(ent) output(elemAnd)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterEq() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterEq());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterEq()", 2, 0, 0, 3, 3, 3);
  assert(tmp=="0e0_5#1e1_5#2e2_5");
  closeLog();
}

define filterEq() {
  for(ent : Ent order by ent.seq) {
    for(elemEq : Elem in ent.col where elemEq.seq == 5) {
      output(ent) output(elemEq)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterNotEq() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterNotEq());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterNotEq()", 2, 0, 0, 3, 3, 27);
  assert(tmp=="0e0_0|0e0_1|0e0_2|0e0_3|0e0_4|0e0_6|0e0_7|0e0_8|0e0_9#1e1_0|1e1_1|1e1_2|1e1_3|1e1_4|1e1_6|1e1_7|1e1_8|1e1_9#2e2_0|2e2_1|2e2_2|2e2_3|2e2_4|2e2_6|2e2_7|2e2_8|2e2_9");
  closeLog();
}

define filterNotEq() {
  for(ent : Ent order by ent.seq) {
    for(elemNotEq : Elem in ent.col where elemNotEq.seq != 5) {
      output(ent) output(elemNotEq)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterIsNull() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterIsNull());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterIsNull()", 2, 0, 0, 3, 3, 3);
  assert(tmp=="0e0_0#1e1_0#2e2_0");
  closeLog();
}

define filterIsNull() {
  for(ent : Ent order by ent.seq) {
    for(elemIsNull : Elem in ent.col where elemIsNull.prev == null) {
      output(ent) output(elemIsNull)
    } separated-by { "|" }
  } separated-by { "#" }
}

function noFilterIsNull() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(noFilterIsNull());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "noFilterIsNull()", 3, 0, 27, 3, 3, 30); // 27 duplicates, because the lazy property next is prefetched, but the entities are already loaded
  assert(tmp=="0e0_9#1e1_9#2e2_9");
  closeLog();
}

define noFilterIsNull() {
  for(ent : Ent order by ent.seq) {
    for(elemIsNull : Elem in ent.col where elemIsNull.next == null) {
      output(ent) output(elemIsNull)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterIsNotNull() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterIsNotNull());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterIsNotNull()", 3, 0, 0, 3, 3, 30); // Also prefetching .prev, so also prefetch the three Elem entities where .prev == null, just not as part of the collection
  assert(tmp=="0e0_1|0e0_2|0e0_3|0e0_4|0e0_5|0e0_6|0e0_7|0e0_8|0e0_9#1e1_1|1e1_2|1e1_3|1e1_4|1e1_5|1e1_6|1e1_7|1e1_8|1e1_9#2e2_1|2e2_2|2e2_3|2e2_4|2e2_5|2e2_6|2e2_7|2e2_8|2e2_9");
  closeLog();
}

define filterIsNotNull() {
  for(ent : Ent order by ent.seq) {
    for(elemIsNotNull : Elem in ent.col where elemIsNotNull.prev != null) {
      output(ent) output(elemIsNotNull)
    } separated-by { "|" }
  } separated-by { "#" }
}

function noFilterIsNotNull() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(noFilterIsNotNull());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "noFilterIsNotNull()", 3, 0, 27, 3, 3, 30); // 27 duplicates, because the lazy property next is prefetched, but the entities are already loaded
  assert(tmp=="0e0_0|0e0_1|0e0_2|0e0_3|0e0_4|0e0_5|0e0_6|0e0_7|0e0_8#1e1_0|1e1_1|1e1_2|1e1_3|1e1_4|1e1_5|1e1_6|1e1_7|1e1_8#2e2_0|2e2_1|2e2_2|2e2_3|2e2_4|2e2_5|2e2_6|2e2_7|2e2_8");
  closeLog();
}

define noFilterIsNotNull() {
  for(ent : Ent order by ent.seq) {
    for(elemIsNotNull : Elem in ent.col where elemIsNotNull.next != null) {
      output(ent) output(elemIsNotNull)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterSmallerThan() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterSmallerThan());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterSmallerThan()", 2, 0, 0, 3, 3, 6);
  assert(tmp=="0e0_0|0e0_1#1e1_0|1e1_1#2e2_0|2e2_1");
  closeLog();
}

define filterSmallerThan() {
  for(ent : Ent order by ent.seq) {
    for(elemSmallerThan : Elem in ent.col where elemSmallerThan.seq < 2) {
      output(ent) output(elemSmallerThan)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterSmallerThanOrEqual() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterSmallerThanOrEqual());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterSmallerThanOrEqual()", 2, 0, 0, 3, 3, 9);
  assert(tmp=="0e0_0|0e0_1|0e0_2#1e1_0|1e1_1|1e1_2#2e2_0|2e2_1|2e2_2");
  closeLog();
}

define filterSmallerThanOrEqual() {
  for(ent : Ent order by ent.seq) {
    for(elemSmallerThanOrEqual : Elem in ent.col where elemSmallerThanOrEqual.seq <= 2) {
      output(ent) output(elemSmallerThanOrEqual)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterLargerThan() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterLargerThan());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterLargerThan()", 2, 0, 0, 3, 3, 6);
  assert(tmp=="0e0_8|0e0_9#1e1_8|1e1_9#2e2_8|2e2_9");
  closeLog();
}

define filterLargerThan() {
  for(ent : Ent order by ent.seq) {
    for(elemLargerThan : Elem in ent.col where elemLargerThan.seq > 7) {
      output(ent) output(elemLargerThan)
    } separated-by { "|" }
  } separated-by { "#" }
}

function filterLargerThanOrEqual() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(filterLargerThanOrEqual());
  var hibLog : HibernateLog := getLog();
  assertLogWithEntities(hibLog, "filterLargerThanOrEqual()", 2, 0, 0, 3, 3, 9);
  assert(tmp=="0e0_7|0e0_8|0e0_9#1e1_7|1e1_8|1e1_9#2e2_7|2e2_8|2e2_9");
  closeLog();
}

define filterLargerThanOrEqual() {
  for(ent : Ent order by ent.seq) {
    for(elemLargerThanOrEqual : Elem in ent.col where elemLargerThanOrEqual.seq >= 7) {
      output(ent) output(elemLargerThanOrEqual)
    } separated-by { "|" }
  } separated-by { "#" }
}

function assertLogWithEntities(hibLog : HibernateLog, name : String, sql : Int, ents : Int, dups : Int, cols : Int, ent : Int, elem : Int) {
  assertLog(hibLog, name, sql, ents + ent + elem, dups, cols);
  assertEntities(hibLog, name, ent, elem);
}

function assertEntities(hibLog : HibernateLog, name : String, ent : Int, elem : Int) {
  assert(hibLog.getEntityCount("Ent")==ent, name + " Ent: " + hibLog.getEntityCount("Ent") + "!=" + ent);
  assert(hibLog.getEntityCount("Elem")==elem, name + " Elem: " + hibLog.getEntityCount("Elem") + "!=" + elem);
}

test {
  filterNotOr();
  filterEq();
  filterNotEq();
  filterIsNull();
  noFilterIsNull();
  filterIsNotNull();
  noFilterIsNotNull();
  filterSmallerThan();
  filterSmallerThanOrEqual();
  filterLargerThan();
  filterLargerThanOrEqual();
}

define page pageFilterNotOr()               { filterNotOr() }
define page pageFilterEq()                  { filterEq() }
define page pageFilterNotEq()               { filterNotEq() }
define page pageFilterIsNull()              { filterIsNull() }
define page pageNoFilterIsNull()            { noFilterIsNull() }
define page pageFilterIsNotNull()           { filterIsNotNull() }
define page pageNoFilterIsNotNull()         { noFilterIsNotNull() }
define page pageFilterSmallerThan()         { filterSmallerThan() }
define page pageFilterSmallerThanOrEqual()  { filterSmallerThanOrEqual() }
define page pageFilterLargerThan()          { filterLargerThan() }
define page pageFilterLargerThanOrEqual()   { filterLargerThanOrEqual() }
