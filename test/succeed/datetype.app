application test

section datamodel

  entity DateTest{
    date :: Date
    time :: Time
    datetime :: DateTime 
  }
  
  var dt : DateTest := DateTest{};
  
  define page home(){
    " date: " output(dt.date)
    " time: " output(dt.time)
    " datetime: " output(dt.datetime)

    form{
      input(dt.date)
      input(dt.time)
      input(dt.datetime)
      
      action("save",save())
    }
    action save()
    {
      dt.save();
      return home();
    }

  }


