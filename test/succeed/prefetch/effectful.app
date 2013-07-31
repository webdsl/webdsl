application effectful

imports module/logutils

entity Employee {
  name :: String
  salary :: Int
}

entity Department {
  name :: String
  employees -> Set<Employee>
}

init {
  Department{name := "d1" employees := {
	    Employee{name := "d1e1" salary:=30000},
	    Employee{name := "d1e2" salary:=40000},
	    Employee{name := "d1e3" salary:=70000},
	    Employee{name := "d1e4" salary:=75000}
    }
  }.save();
  Department{name := "d2" employees := {
	    Employee{name := "d2e1" salary:=30000},
	    Employee{name := "d2e2" salary:=40000},
	    Employee{name := "d2e3" salary:=70000},
	    Employee{name := "d2e4" salary:=75000}
    }
  }.save();
}

page root() {
}

template effectful() {
  for(e : Employee) { // For-all loop using a criteria query
    if (e.salary > 65000) {
      output(e.salary)
    } else {
      "Salary too low" // Also effectful, because it depends on the existence of employees with a salary of 65000 or below
    }
  }
}

template collection() {
  var d : Department := (from Department as d where d.name='d1')[0];
  for(e : Employee in d.employees) { // For loop using a collection property
    if (e.salary > 65000) {
      output(e.salary)
    } else {
      "Salary too low" // Also effectful, because it depends on the existence of employees with a salary of 65000 or below
    }
  }
  // Using the same collection again. If the previous loop used a (.salary > 65000 || .salary <= 65000) filter, then
  // this loop is likely to fetch the collection again with an extra query.
  for(e : Employee in d.employees) { 
    "Employee"
  }
}

template outerloop() {
  var d : Department := (from Department as d where d.name='d1')[0];
  for(e1 : Employee in d.employees) { // Should not fetch d1e1 or d1e2, should only fetch d1e3 and d1e4 
    if(e1.salary >= 70000) { // This condition should be applied on e1, because of the effectful statement on e2, which depends on the existence of e1
      for (e2 : Employee in (from Employee as e3 where e3.salary=~e1.salary and e3.id!=~e1.id) ) { // HQL query is not effectful and uses e1 to select e2, however, the analysis result for e2 cannot be directly translated to e1
        output(e2) // This is the only effectful statement and does not use e1 directly
      }
    }
  }
}

function assertData(name : String, data : String) {
  assert(data.contains("Salary too low"), name + ": Salary too low not found");
  assert(data.contains("70000"), name + ": 70000 not found");
  assert(data.contains("75000"), name + ": 75000 not found");
  assert(!data.contains("30000"), name + ": 30000 found");
  assert(!data.contains("40000"), name + ": 40000 found");
}

test {
  clearSession();
  initLog();
  var tmp : String := rendertemplate(effectful());
  var hibLog : HibernateLog := getLog();
  assertLog(hibLog, "effectful()", 1, 8, 0, 0); // Entities: All employees (8)
  assertData("effectful()", tmp);
  closeLog();

  clearSession();
  initLog();
  tmp := rendertemplate(collection());
  hibLog := getLog();
  assertLog(hibLog, "collection()", 2, 5, 0, 1); // Entities: d1, d1e1, ... and d1e4
  assertData("collection()", tmp);
  closeLog();

  clearSession();
  initLog();
  tmp := rendertemplate(outerloop());
  hibLog := getLog();
  assertLog(hibLog, "outerloop()", 4, 5, 0, 1); // Entities: d1, d1e3, d1e4, d2e3, d2e4
  assert(tmp.contains("d2e3"), "outerloop(): d2e3 not found");
  assert(tmp.contains("d2e4"), "outerloop(): d2e4 not found");
  closeLog();
}
