domain org.webdsl.wiki

User {

  id       : Long   (Id, GeneratedValue) // or do we always have this?
  username : String
  fullname : String
  password : String
  email    : String
  url      : String

  topics   : Set<Topic>

}

Topic {

  isroot    : Boolean
  title     : String
  mimetype  : String
  text      : Text    // strings are not strings in db world
  
  subtopics : Map<String, Topic> (Cascade(SAVE_UPDATE,MERGE))
  authors   : Set<User>          (Cascade(SAVE_UPDATE,MERGE))

}