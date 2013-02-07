application test

imports module/logutils

entity Ent {
  name :: String
  propA -> Sub
  propB -> Sub
  lst -> List<Sub>
  set -> Set<Sub>
  lazy -> Sub // (inverse = Sub.owning)
}

entity Sub {
  name :: String
  owning -> Ent (inverse = Ent.lazy)
}

init {
  var s : List<Sub>;
  var tmp : Sub;
  for(i : Int from 0 to 11) {
    tmp := Sub{ name := "s" + i };
    tmp.save();
    s.add(tmp);
  }

  var e1 : Ent := Ent { name := "e1" propA := s[0] propB := s[3] lazy := s[2] lst := [s[0]] set := {s[3]} };
  var e2 : Ent := Ent { name := "e2" propA := s[1] propB := s[4] lazy := s[5] lst := [s[7]] set := {s[9]} };
  var e3 : Ent := Ent { name := "e3" propA := s[2] propB := s[5] lazy := s[6] lst := [s[8]] set := {s[10]} };
  e1.save();
  e2.save();
  e3.save();
}

page root() {
  allEnts
}

template allEnts() {
  table {
    column { <b>"name"</b> }
    column { <b>"propA"</b> }
    column { <b>"propB"</b> }
    column { <b>"lst"</b> }
    column { <b>"set"</b> }
    column { <b>"lazy"</b> }
    for(e : Ent order by e.name asc) {
      row{
        outputColumns(e)
      }
    }
  }
}

template outputColumns(e : Ent) {
  column { output(e.name) }
  column { output(e.propA) }
  column { output(e.propB) }
  column { output(e.lst) }
  column { output(e.set) }
  column { output(e.lazy) }
}

test {
  clearSession();
  initLog();

  var tmp : String := rendertemplate(allEnts());
  var hibLog : HibernateLog := getLog();
  assertLog(hibLog, "root()", 5, 14, 0, 6);
  // In case of 7 queries the problem is probably caused by batches for propA and propB not being combined.
  // If there are any duplicates then one of the following scenarios is likely: 
  // s0 is duplicate if it is fetched by properties propA and lst, which should not happen if the batch of propA is executed after the batch of lst
  // s2 is duplicate if it is fetched by properties propA and lazy, which should not happen if the batch of propA is executed after the batch of lazy and the lazy batch properly initialized proxies
  // s3 is duplicate if it is fetched by properties propB and set, which should not happen if the batch of propB is executed after the batch of set
  // s5 is duplicate if it is fetched by properties propB and lazy, which should not happen if the batch of propB is executed after the batch of lazy and the lazy batch properly initialized proxies
  closeLog();
}