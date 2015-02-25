application test

imports module/logutils

entity Root {
  sub -> Child
  a -> Child
  b -> Child
  alt -> Alt
  default -> Default
  redef -> Redef

  extend function Root() {
    sub := Child{};
    a := Child{};
    b := Child{};
    alt := Alt{};
    default := Default{};
    redef := Redef{};
  }
}

entity Child {
  alt -> Alt
  default -> Default
  redef -> Redef

  extend function Child() {
    alt := Alt{};
    default := Default{};
    redef := Redef{};
  }
}

entity Alt {}
entity Default {}
entity Redef {}

function size() : Int {
  return 6;
}

init {
  for(i : Int from 0 to size()) {
    Root{}.save();
  }
}

page root() {
  redef(Child{})
  redef2(Child{}, Child{})
  redefRootAlt(Root{})
  redefAlt(Child{})
  redef2Alt(Child{}, Child{})
  default()
  same()
  sameAlt()
  calleeRedef()
  callee(Root{})
  callerRedef()
  callerCallee()
}

template redefRoot(r : Root) {
  output(r.default)
}

template redef(c : Child) {
  output(c.default)
}

template redef2(a : Child, b : Child) {
  output(a.default)
  output(b.default)
}

template redefRootAlt(r : Root) {
  output(r.alt)
}

template redefAlt(c : Child) {
  output(c.alt)
}

template redef2Alt(a : Child, b : Child) {
  output(a.alt)
  output(b.alt)
}

template default() {
  for(r : Root) {
    redefRoot(r)
    redef(r.sub)
    redef2(r.a, r.b)
  }
}

function default() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(default());
  var hibLog : HibernateLog := getLog();
  assertDefault(hibLog, "default()");
  closeLog();
}

template same() {
  for(r : Root) {
    redefRoot(r)
    redef(r.sub)
    redef2(r.a, r.b)
  }
  define redefRoot(r : Root) {
    output(r.redef)
  }
  define redef(c : Child) {
    output(c.redef)
  }
  define redef2(a : Child, b : Child) {
    output(a.redef)
    output(b.redef)
  }
}

function same() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(same());
  var hibLog : HibernateLog := getLog();
  assertRedef(hibLog, "same()");
  closeLog();
}

template sameAlt() {
  for(r : Root) {
    redefRoot(r)
    redef(r.sub)
    redef2(r.a, r.b)
  }
  define redefRoot(r : Root) = redefRootAlt
  define redef(c : Child) = redefAlt
  define redef2(a : Child, b : Child) = redef2Alt
}

function sameAlt() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(sameAlt());
  var hibLog : HibernateLog := getLog();
  assertAlt(hibLog, "sameAlt()");
  closeLog();
}

template calleeRedef() {
  for(r : Root) {
    callee(r)
  }
}

template callee(r : Root) {
  redefRoot(r)
  redef(r.sub)
  redef2(r.a, r.b)
  define redefRoot(r1 : Root) = redefRootAlt
  define redef(c : Child) = redefAlt
  define redef2(a : Child, b : Child) = redef2Alt
}

function calleeRedef() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(calleeRedef());
  var hibLog : HibernateLog := getLog();
  assertAlt(hibLog, "calleeRedef()");
  closeLog();
}

template callerRedef() {
  callerCallee

  define redefRoot(r : Root) = redefRootAlt
  define redef(c : Child) = redefAlt
  define redef2(a : Child, b : Child) = redef2Alt
}

template callerCallee() {
  for(r : Root) {
	  redefRoot(r)
	  redef(r.sub)
	  redef2(r.a, r.b)
  }
}

function callerRedef() {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(callerRedef());
  var hibLog : HibernateLog := getLog();
  assertAlt(hibLog, "callerRedef()");
  closeLog();
}

function assertDefault(hibLog : HibernateLog, name : String) {
  var size : Int := size();
  assertEntities(hibLog, name, size, size * 3, size * 4, 0, 0);
}

function assertRedef(hibLog : HibernateLog, name : String) {
  var size : Int := size();
  assertEntities(hibLog, name, size, size * 3, 0, size * 4, 0);
}

function assertAlt(hibLog : HibernateLog, name : String) {
  var size : Int := size();
  assertEntities(hibLog, name, size, size * 3, 0, 0, size * 4);
}

function assertEntities(hibLog : HibernateLog, name : String, root : Int, child : Int, default : Int, redef : Int, alt : Int) {
  assertLog(hibLog, name, 6, root + child + default + redef + alt, 0, 0);
  assert(hibLog.getEntityCount("Root")==root, name + " Root: " + hibLog.getEntityCount("Root") + "!=" + root);
  assert(hibLog.getEntityCount("Child")==child, name + " Child: " + hibLog.getEntityCount("Child") + "!=" + child);
  assert(hibLog.getEntityCount("Default")==default, name + " Default: " + hibLog.getEntityCount("Default") + "!=" + default);
  assert(hibLog.getEntityCount("Redef")==redef, name + " Redef: " + hibLog.getEntityCount("Redef") + "!=" + redef);
  assert(hibLog.getEntityCount("Alt")==alt, name + " Alt: " + hibLog.getEntityCount("Alt") + "!=" + alt);
}

test{
  default();
  same();
  sameAlt();
  calleeRedef();
  callerRedef();
}