// http://yellowgrass.org/issue/WebDSL/298
// lots of lifting causes the compiler to run into limitation of stratego Java back-end

application test

  entity Publication{}
  entity AbstractAuthor{}
  entity Alias{}
  entity Person{}
  entity Affiliation{}
  entity EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn{}
  
  define page root(){
    
  }
  define span selectPersonAffiliationFromListtttttttttttttttttttttttttttttttttttttt(alias : Alias, pers : Person, affil : Affiliation, foo:EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn) {}
  define span selectAuthorFromList(pub : Publication, author : AbstractAuthor) {
    define span selectPersonAffiliationFromListtttttttttttttttttttttttttttttttttttttt(alias : Alias, pers : Person, affil : Affiliation, foo:EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn) {
      action("Select", action{ var x := Or [i==3 | i:Int in [1,[j|j:Int in [1,2,3]][0],3,4]]; })
    }
  }