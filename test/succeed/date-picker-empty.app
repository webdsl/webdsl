application datepicker

  entity DateHolder {
    datetime :: DateTime
    time :: Time
    date :: Date (not null)
  }

  var dh := DateHolder{ datetime := null time := null date := null };

  define page root() {
    form {
      label("datetime: "){
        input(dh.datetime)
      }
      label("time: "){
        input(dh.time)
      }
      label("date: "){
        input(dh.date)
      }
      submit("Save", action{})
    }
  }
