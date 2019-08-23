//error: Entity type 'Stdent' not defined
//error: Variable 'z' not defined
//error: Entity type 'Student' not defined
//error: Entity type 'Project' not defined
//#3 error: No property 'str' defined for entity type 'TestEnt'
//warning: No property 'question' defined for entity type 'Assignment'. However, it is defined for subtype 'BasicAssignment' which is supported in HQL because they map to the same table
//warning: No property 'b' defined for entity type 'A'. However, it is defined for subtype 'B' which is supported in HQL because they map to the same table
//warning: No property 'c' defined for entity type 'A'. However, it is defined for subtype 'C' which is supported in HQL because they map to the same table
//warning: No property 'd' defined for entity type 'A'. However, it is defined for subtype 'D' which is supported in HQL because they map to the same table
//warning: No property 'e' defined for entity type 'A'. However, it is defined for subtype 'E' which is supported in HQL because they map to the same table
//warning: No property 'f' defined for entity type 'A'. However, it is defined for subtype 'F' which is supported in HQL because they map to the same table
//warning: No property 'g' defined for entity type 'A'. However, it is defined for subtype 'G' which is supported in HQL because they map to the same table
//Derived property 'TestEnt.derived' not allowed in query

application test

page root(){}

entity TestEnt {
  set : {TestEnt}
  list : [TestEnt]
  string : String
  derived : String := ""
}

entity Assignment {}
entity BasicAssignment : Assignment { question : Question }
entity SubAssignment : BasicAssignment { subprop : Int }
entity Question {}

entity A {}
entity B : A { b : B }
entity C : A { c : C }
entity D : A { d : D }
entity E : C { e : E }
entity F : C { f : F }
entity G : C { g : G }

template tmp(){
  var a := from Stdent as s
  var b := from Student as s, Project as p where s.property = p.id and s.name = ~z.name and s.id = p.id
  var c := from TestEnt as te where te in elements(te.set) or te member of te.list and te.string = '1' and te.str = '1'
  var d := from TestEnt as te, TestEnt as te2 where te2 in elements(te.set) or te member of te2.list and te.string = '1' and te.str = '1' and te2.str = '1'
  var e := from Assignment as a where a.question.version != a.version and 2 = a.subprop
  var f := from A as a where a.id = a.b.id and a.c.id = a.d.id and a.e.id = a.f.id and a.g.id = a.id
  var h := from TestEnt as x where x.derived is null
}