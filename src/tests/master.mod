name: master-flow

description

  This application supports the tracking of the progress
  of students in a master's program by students and faculty.

end description


User {
  username : String [format : alphanum+]
  fullname : String [format : {alphanum+ " "}+]
  email    : String [format : alphanum+@...]
  password : String
  role     : Set<Role>
}

enum Role [
  coordinator
  student
  supervisor
  chair
]

Course {
  title   : String
  code    : String
  credits : Int
  period  : Int
  
}

ResearchAssignment {
  title      : String
  student    : User
  supervisor : User
  start      : Date
  finish     : Data
}

Thesis {
  title      : String
  student    : User [ role == student ]
  supervisor : User [ role == supervisor ]
  start      : Date
  graduation : Date
}

Master {
  student : User
  specialization : Specialization
  courses : Set<Course>
  assign  : ResearchAssignment
  thesis  : Thesis
  stage   : Stage
}

enum Specialization [
  se
  pds
]

enum Stage [
  start
  assignment
  thesis
  graduated
]

screen createUser role is {
  create new User;
}

screen login {
  user := enter User.username, User.password, User.role;
  user should exist;
  session.loggedin := user;
}

screen start role is coordinator {
  user := select or create User;
  master := create Master [student := user];
}