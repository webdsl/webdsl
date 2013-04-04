application test

section datamodel

  entity User{
    name :: String
    address :: String
    val :: Int
    color -> Color
  }

  entity Moderator : User {
  }

  entity Admin : Moderator {
  }

  entity Color {
    name :: String
  }

  var t_u1 := Admin{ name := "test1" address := "1" val := 2 }
  var t_u2 := User{ name := "test2" address := "1" val := 3 }
  var t_u3 := User{ name := "test3" address := "2" val := 5 }
  var t_u4 := Moderator{ name := "test4" address := "2" val := 1 }
  var red := Color { name := "Red" }
  var blue := Color { name := "Green" }
  var green := Color { name := "Blue" }

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
    t_u1.color := red;
    t_u2.color := blue;
    t_u3.color := green;
    t_u4.color := red;
  }

  page p() {
    var a : List<User> := select u from Moderator as u where u.class='Admin';
    var ms : List<User> := from Moderator order by name asc;
    var m : List<User> := select u from User as u where u.class='Moderator' order by u.name asc;
    section {
      header { "Admin" }
      output(a)
    }
    section {
      header { "Moderators" }
      output(ms)
    }
    section {
      header { "Moderator" }
      output(m)
    }
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

    var a : List<User> := select u from Moderator as u where u.class='Admin';
    assert(a.length == 1);
    assert( a[0] == t_u1 );

    var ms : List<User> := from Moderator order by name asc;
    assert(ms.length == 2);
    assert( ms[0] == t_u1 );
    assert( ms[1] == t_u4 );

    var m : List<User> := select u from User as u where u.class='Moderator' order by u.name asc;
    assert(m.length == 1);
    assert( m[0] == t_u4 );

    var c : List<Color> := select distinct u.color from User as u;
    assert(c.length == 3);
    assert( blue in c );
    assert( green in c );
    assert( red in c );

    var uids : List<UUID> := select id from User order by name asc;
    assert(uids.length == 4);
    assert( uids[0] == t_u1.id );
    assert( uids[1] == t_u2.id );
    assert( uids[2] == t_u3.id );
    assert( uids[3] == t_u4.id );
  }
