application org.webdsl.master

description

  This application supports the tracking of the progress
  of students in a master's program by students and faculty.

end

section people.

  Person {
    fullname  : String
    addresses : Map<String,Address>
    homepages : Set<URL>
    user      : User?
  }

  User {
    username : String (unique)
    email    : String (unique)
    password : String
    person   : Person
    role     : Set<Role>
  }

  // probably attach additional information to (some) roles
  // e.g., student has student number
  // is enum then a good model?

  //enum Role {
  //  coordinator
  //  student
  //  supervisor
  //  lecturer
  //  chair
  //  admin
  //}

  // when creating UI, infer names for roles from names for subclasses
  // of role

  Role {
    user : User
  }

  Admin : Role {}

  Chair : Role {}

  Coordinator : Role {}

  Student : Role {
    number : String
    year   : Int
  }

  Lecturer : Role {
    courses : Set<Course>
  }

  Supervisor : Role {
    students : Set<Student>
  }
  
  // Session {}
  
  //menu {
  //  menu {
  //    if (session.loggedin) { editUser() }
  //  }
  //}

  action createUser
  {
    user        := create User;   // create input form to get data
    person      := create Person;
    person.user := user;
    user.person := person;
  }

  action login {
    user := enter User.username, User.password, User.role;
    if (find User user)
      session.loggedin := user;
    else
      createUser();
  }

section courses or educational units.

  EduUnit {
    title   : String
    code    : String
    credits : Int
  }

  Course {
    unit     : EduUnit
    year     : Year
    period   : Period
    lecturer : Person
  }

  StudentCourse {
    course  : Course
    student : Person // (.user.role has student)
    exam    : Date?
    grade   : Int?   // (0 .. 10)
  }

  Project {
    unit        : EduUnit
    topic       : String
    description : Text
    student     : Set<Person>
    supervisor  : Set<Person>
    start       : Date
    finish      : Data
  }

  ResearchAssignment : Project {
  }

  ThesisProject : Project {
    milestones : List<Document>
    website    : URL
    subversion : URL
    // include a pointer to the research projects a thesis project
    // is affiliated with
  }

  Document {
    doc      : PDF
    date     : Date
    comments : Text
  }

section tracking students in a master program.

  StudentMaster {
    student        : User
    specialization : Specialization
    courses        : Set<Course>
    research       : ResearchAssignment
    thesis         : ThesisProject
    start          : Date
    ending         : Date 
    status         : MasterStatus
  }

  Specialization : String {}

  //enum MasterStatus {
  //  started
  //  assignment
  //  thesis
  //  graduated
  //}

  MasterStatus {}
  Started : MasterStatus {}
  Assignment : MasterStatus {}
  Thesis : MasterStatus {}
  Graduated : MasterStatus {}

  rules

    sum(Master.courses.credits) = 60

    sum(Master.courses.credits) 
    + Master.research.credits 
    + Master.thesis = 120

    // courses.credits is an implicit map; maybe adopt an xpath 
    // style projection syntax

  //note 
  //  we want all kinds of views of the student population; it would
  //  be nice to generate a table that can be reordered interactively
  //  by selecting a particular column
  //end

  action activeStudentPopulation {
    for (x in StudentMaster where x.status != graduated ordered by start ascending)
      {
        show x.student.person.fullname, x.start, x.end, x.status;
      }
  }
