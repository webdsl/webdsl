application test

section datamodel

  entity User{
    name :: String
    address :: String
    val :: Int
  }

  var t_u1 := User{ name := "test1" address := "1" val := 2 }
  var t_u2 := User{ name := "test2" address := "1" val := 3 }
  var t_u3 := User{ name := "test3" address := "2" val := 5 }
  var t_u4 := User{ name := "test4" address := "2" val := 1 }

 
  define page root(){
    form{
      for(u1:User)
      {
        output(u1)
        output(u1.name)
        output(u1.address)
      }
    }
    "test page"
    var u : User := User{ name := "bob" address := "somewhere 1" };
    form{
      input(u.name)
      input(u.address)

      action("save",save())
    }

    action save() {
      u.save();
    }


  }


  define page user(u:User){
    "1 "
    var ps : List<User> :=
      select p from User as p
      where (~u = p)

    list{
      for(pers : User in ps) {
        listitem{ output(pers) }
      }
    }
    "2 " 
    var s := "test%"
    var ps2 : List<User> :=
      from User as u where u.name like ~s;

    list{
      for(pers : User in ps2) {
        listitem{ output(pers) }
      }
    }
  }
  
  
 
  entity Tag{
    name :: String 
    project -> Project
  }
  entity Issue{
    name :: String
    tags -> Set<Tag>
  }
  function abc(tags:List<Issue>){
    
  }
  entity Project {
    name      :: String
    val       :: Int
    function getCommonIssues(nr : Int) : List<Issue>{
      var issues :=
        //select new Tag(t.name)
        select i
        from Issue as i left join i.tags as t;

      abc(issues);
      
      return issues;
    }
  }
  
  var t_p := Project {name := "p1" val := 1}
  var t_t := Tag{ name := "tag1" }
  var t_i := Issue { }

  init {
    t_t.project := t_p;
    t_i.tags.add(t_t);
  }
    
  test queries {
    assert(t_p.getCommonIssues(1).length == 1);

    var x : List<Tag> := (select t from Issue as i left join i.tags as t ) as List<Tag>;
    assert(x.length == 1);

    var i := 2;
    assert((from User limit ~i).length == 2);

    var ps : List<User> := select p from User as p where ~t_u1 = p or p = ~t_u2 and p = ~t_u3;
    assert(ps.length == 1);
    assert(ps[0] == t_u1);

    var s := "test%";
    var ps2 : List<User> := from User as u where u.name like ~s;
    assert(ps2.length == 4);

    var ps3 : List<User> := from User as u where u not in ~ps;
    assert(ps3.length == 3);

    var ps4 : List<User> := from User as u where u in (~t_u2, ~t_u3) and name like ~s;
    assert(ps4.length == 2);

    var issue : List<Issue> := from Issue as i left join i.tags as t left join t.project as p where p.name = 'p1';
    assert(issue.length == 1);

    var p : List<Project> := from Project where not val <= -1 and val >= 1;
    assert(p.length == 1);

    var t : List<Tag> := from Tag as t where t in (from Tag as t2 where project.name <> t.name);
    assert(t.length == 1);

    var u : List<User> := from User as u where u.val in (select max(val) from User as u2 where u2.address = u.address and val > 0 and not u is null);
    assert(u.length == 2);
    assert( (u[0] == t_u2 && u[1] == t_u3) || (u[0] == t_u3 && u[1] == t_u2) );

  }
