application effectful

imports module/logutils

entity Employee {
  salary :: Int
}

entity Department {
  employees -> Set<Employee>
}

init {
  Department{employees := {Employee{salary:=30000}, Employee{salary:=40000}, Employee{salary:=70000}, Employee{salary:=75000}}}.save();
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
  var d : Department := (from Department)[0];
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

function assertData(name : String, data : String) {
  assert(data.contains("Salary too low"), name + ": Salary too low not found");
  assert(data.contains("70000"), name + ": 70000 not found");
  assert(data.contains("75000"), name + ": 75000 not found");
  assert(!data.contains("30000"), name + ": 30000 found");
  assert(!data.contains("40000"), name + ": 30000 found");
}

test {
  clearSession();
  initLog();
  var tmp : String := rendertemplate(effectful());
  var hibLog : HibernateLog := getLog();
  assertLog(hibLog, "effectful()", 1, 4, 0, 0);
  assertData("effectful()", tmp);
  closeLog();

  clearSession();
  initLog();
  tmp := rendertemplate(collection());
  hibLog := getLog();
  assertLog(hibLog, "collection()", 2, 5, 0, 1);
  assertData("collection()", tmp);
  closeLog();
}
