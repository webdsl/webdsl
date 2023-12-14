//#11 collides with a generated function
//warning: 'loadEntity' will always return an entity, even if it doesn't exist

application test

page root(){}

function cancel {}
function cancel( i: Int ){}
function cancel( i: Int, s: String ){}

function replace {}
function replace( i: Int ){}
function replace(i:Int,s:String){}

function rollback {}
function rollback( i: Int ){}
function rollback( i: Int, s: String ){}

function loadEntity( ent: String, eid: UUID ){}
function getEntity( ent: String, eid: UUID ){}

entity Ent {
  function replace(){}
  function cancel(){}
  function rollback(){}
}

function load(eid : UUID){
	loadEntity("Ent", eid);
}