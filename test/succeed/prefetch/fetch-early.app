application test

imports module/logutils

entity Root {
  values -> List<IntEnt>
  show -> Show
  orderKey -> OrderKey
  late -> Late

  // The aggregation operation cannot be translated into a query condition
  function show() : Bool {
  	var sum : Int := 0;
  	for(int : IntEnt in values) {
  		sum := sum + int.value;
  	}
  	return sum >= 5;
  }
}

entity IntEnt {
  value :: Int
}

entity OrderKey {}
entity Late {}
entity Show {
	show :: Bool
}

init {
	for(i : Int from 0 to 10) {
		Root{ values := [ IntEnt{ value := i } ] show := Show{ show := i >= 5 } orderKey := OrderKey{} late := Late{} }.save();
	}
}

page root(){ withCondition }

page unused(){ noCondition }

template noCondition() {
	for(r : Root where r.show() order by r.orderKey asc) {
		output(r.late)
	}
}

function noCondition() {
  clearSession();
  initLog();

  var name : String := "noCondition()";
  var tmp : String := rendertemplate(noCondition());
  var hibLog : HibernateLog := getLog();
  var root : Int := 10;
  var intEnt : Int := 10;
  var show : Int := 0;
  var orderKey : Int := 10;
  var late : Int := 5;
  assertLog(hibLog, name, 4, root + intEnt + show + orderKey + late, 0, 10);
  assert(hibLog.getEntityCount("Root")==root, name + " Root: " + hibLog.getEntityCount("Root") + "!=" + root);
  assert(hibLog.getEntityCount("IntEnt")==intEnt, name + " IntEnt: " + hibLog.getEntityCount("IntEnt") + "!=" + intEnt);
  assert(hibLog.getEntityCount("Show")==show, name + " Show: " + hibLog.getEntityCount("Show") + "!=" + show);
  assert(hibLog.getEntityCount("OrderKey")==orderKey, name + " OrderKey: " + hibLog.getEntityCount("OrderKey") + "!=" + orderKey);
  assert(hibLog.getEntityCount("Late")==late, name + " Late: " + hibLog.getEntityCount("Late") + "!=" + late);
  closeLog();
}

template withCondition() {
  for(r : Root where r.show.show order by r.orderKey asc) {
    output(r.late)
  }
}

function withCondition() {
  clearSession();
  initLog();

  var name : String := "withCondition()";
  var tmp : String := rendertemplate(withCondition());
  var hibLog : HibernateLog := getLog();
  var root : Int := 5;
  var intEnt : Int := 0;
  var show : Int := 5;
  var orderKey : Int := 5;
  var late : Int := 5;
  assertLog(hibLog, name, 3, root + intEnt + show + orderKey + late, 0, 0); // There is no query for Show, because it is join-fetched on Root in order at use the condition (this only happens on ForAll loops)
  assert(hibLog.getEntityCount("Root")==root, name + " Root: " + hibLog.getEntityCount("Root") + "!=" + root);
  assert(hibLog.getEntityCount("IntEnt")==intEnt, name + " IntEnt: " + hibLog.getEntityCount("IntEnt") + "!=" + intEnt);
  assert(hibLog.getEntityCount("Show")==show, name + " Show: " + hibLog.getEntityCount("Show") + "!=" + show);
  assert(hibLog.getEntityCount("OrderKey")==orderKey, name + " OrderKey: " + hibLog.getEntityCount("OrderKey") + "!=" + orderKey);
  assert(hibLog.getEntityCount("Late")==late, name + " Late: " + hibLog.getEntityCount("Late") + "!=" + late);
  closeLog();
}

test{
	noCondition();
  withCondition();
}
