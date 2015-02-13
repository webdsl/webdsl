application test

section datamodel


page root(){
}

entity Person{
  function identifyCoauthor(a: Person, b: Alias, c : Affiliation){

  }
}

entity Alias{
}

entity Affiliation{

}

define span selectPersonFromList(alias : Alias, pers : Person) {
  "selectPersonFromList undefined"
}

define span selectPersonAffiliationFromList(alias : Alias, pers : Person, affil : Affiliation) {
  "selectPersonAffiliationFromList undefined"
}

define span selectCoauthorFromList(pers : Person, alias : Alias) {
  define span selectPersonFromList(alias1 : Alias, coauthor : Person) {
    action("Select", action{
      var a : Affiliation := null;
      pers.identifyCoauthor(coauthor, alias1, a);
    })
  }
  define span selectPersonAffiliationFromList(alias1 : Alias, coauthor : Person, affil : Affiliation) {
    action("Select", action{
      pers.identifyCoauthor(coauthor, alias1, affil);
    })
  }
}