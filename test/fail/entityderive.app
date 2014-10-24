//Must derive from an entity type
//Entity 'User' does not have a property 'name1'
//Entity 'User' does not have a property 'pass1'

application test

  entity User{
  	name : String
  	pass : String
  	test : Int
  }

  page root(){
  	testderive(234 with name pass test)
  	testderive(User{} with name1 pass1 test)
  }


  template testderive(u:e with p){
    foreach p {
      input(u.p)
      "-"
    }
  }

  template showit(u:e with p(labels : String)){
    foreach p {
      output(u.p)
      "-"
    }
  }