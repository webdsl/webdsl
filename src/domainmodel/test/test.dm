domain blog

concept BlogEntry {

  title    : String
  contents : String
  date     : Date
  tags     : [Tag]
  replies  : [Reply]
  
}

concept Tag {

  tagName : String
  
}

concept Reply {

  contents : String
  date     : Date
  user     : User 
 // level    : {GOOD, AVERAGE, BAD}
  
}

concept User {

  name        : String       (unique,a) // ,displaykey, .., @Column(name=mycolumnname))  
  blogEntries : [BlogEntry]

}
