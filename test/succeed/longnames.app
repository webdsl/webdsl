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
    var s := "123"
    bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb(s,EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn{})
  }
  define span selectPersonAffiliationFromListtttttttttttttttttttttttttttttttttttttt(alias : Alias, pers : Person, affil : Affiliation, foo:EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn) {}
  define span selectAuthorFromList(pub : Publication, author : AbstractAuthor) {
    define span selectPersonAffiliationFromListtttttttttttttttttttttttttttttttttttttt(alias : Alias, pers : Person, affil : Affiliation, foo:EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn) {
      action("Select", action{ var x := Or [i==3 | i:Int in [1,[j|j:Int in [1,2,3]][0],3,4]]; })
    }
  }
  
  define bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb(s:Ref<String>,b:EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn){
    var tmp :=EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn{}
    par{form{div{block{submit action{log(tmp);} { 
      aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa(s,b)
    }}}}}
  }
  
  define aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa(s:Ref<String>,b:EntityWithAVeryLongNameCanBecomeAnIssueAgainnnnnnnnnnnnnnnnnnnnn){
    output(s.getEntity().toString())
  }
  
