application test
/*
 define ajax editLecture(lecture : Lecture) {
   form{
     par{ label("Key"     ){ input(lecture.key)      } }
     par{ label("Public"  ){ input(lecture.public)   } }
     submit("Save", action{ refresh(); })[ajax]
   }
   form{ submit("Cancel", action{ refresh(); })[ajax] }
 }*/
 
 
 define ajax editLecture(lecture : Lecture) {
   form{
     par{ label("Key"     ){ input(lecture.key)      } }
     par{ label("Title"   ){ input(lecture.title)    } }
     par{ label("Date"    ){ input(lecture.date)     } }
     par{ label("Time"    ){ input(lecture.time)     } }
     par{ label("Room"    ){ input(lecture.room)     } }
     par{ label("Public"  ){ input(lecture.public)   } }
     par{ label("Abstract"){ input(lecture.abstract) } }
     par{ label("Slides"  ){ input(lecture.slides)   } }
     par{ label("Notes"   ){ input(lecture.notes)    } }
     action("Save", action{ refresh(); })[ajax]
   }
   form{ action("Cancel", action{ refresh(); })[ajax] }
 }
 
 entity Lecture{
   key :: String
   public :: Bool
   date :: Date
   time :: Time
   room :: String
   abstract :: String
   slides :: String
   notes :: String
   title :: String
 }
 
 var l1 := Lecture{
   key := "gdgdgdfg"
   public := true
 }
 
 define page root(){
   placeholder bla {
     "default " 
   }
   container[onclick=action{ replace(bla,editLecture(l1)); }]{"click here"}
 }
