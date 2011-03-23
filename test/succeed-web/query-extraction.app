application test

native class java.util.UUID as UUID {
	static fromString(String) : UUID
}

native class org.hibernate.stat.Statistics as Statistics {
  setStatisticsEnabled(Bool)
  getCollectionFetchCount() : Long
  getCollectionLoadCount() : Long
  getEntityFetchCount() : Long
  getEntityLoadCount() : Long
}

native class org.hibernate.SessionFactory as SessionFactory {
  getStatistics() : Statistics
}

native class utils.HibernateUtilConfigured as HibernateUtilConfigured {
  static getSessionFactory() : SessionFactory
}

entity Auction{
  item -> Item (inverse = Item.auction)
  bids -> List<Bid>
  seller -> User
}
  
entity Item{
  auction -> Auction
  name :: String
}

entity Bid{
  offer :: Float
  auction -> Auction (inverse = Auction.bids)
  buyer -> User (inverse = User.bids)
}

entity User{
  name :: String
  bids -> List<Bid>
  auctions -> List<Auction> (inverse = Auction.seller)
}

init {
  var u1 := User{ name := "User 1" };
  u1.save();
  var u2 := User{ name := "User 2" };
  u2.save();

  var i1 := Item{ name := "Item 1" };
  i1.save();
  var i2 := Item{ name := "Item 2" };
  i2.save();
  var i3 := Item{ name := "Item 3" };
  i3.save();
  var i4 := Item{ name := "Item 4" };
  i4.save();

  var a1 := Auction{ item := i1 seller := u1 };
  a1.save();
  var a2 := Auction{ item := i2 seller := u1 };
  a2.save();
  var a3 := Auction{ item := i3 seller := u2 };
  a3.save();
  var a4 := Auction{ item := i4 seller := u2 };
  a4.save();

  var b1 := Bid{ offer := 1.0 auction := a1 buyer := u2 };
  b1.save();
  var b2 := Bid{ offer := 2.0 auction := a1 buyer := u2 };
  b2.save();
  var b3 := Bid{ offer := 1.0 auction := a3 buyer := u1 };
  b3.save();
  var b4 := Bid{ offer := 1.0 auction := a4 buyer := u1 };
  b4.save();
}

/*
var u1 := User{ name := "User 1" };
var u2 := User{ name := "User 2" };

var i1 := Item{ name := "Item 1" };
var i2 := Item{ name := "Item 2" };
var i3 := Item{ name := "Item 3" };
var i4 := Item{ name := "Item 4" };

var a1 := Auction{ item := i1 seller := u1 };
var a2 := Auction{ item := i2 seller := u1 };
var a3 := Auction{ item := i3 seller := u2 };
var a4 := Auction{ item := i4 seller := u2 };

var b1 := Bid{ offer := 1.0 auction := a1 buyer := u2 };
var b2 := Bid{ offer := 2.0 auction := a1 buyer := u2 };
var b3 := Bid{ offer := 1.0 auction := a3 buyer := u1 };
var b4 := Bid{ offer := 1.0 auction := a4 buyer := u1 };
*/  
/*var b4 := Bid{ offer := 1.0 auction := a4 buyer := u1 };
var b3 := Bid{ offer := 1.0 auction := a3 buyer := u1 };
var b2 := Bid{ offer := 2.0 auction := a1 buyer := u2 };
var b1 := Bid{ offer := 1.0 auction := a1 buyer := u2 };

var a1 := Auction{ item := i1 seller := u1 };
var a2 := Auction{ item := i2 seller := u1 };
var a3 := Auction{ item := i3 seller := u2 };
var a4 := Auction{ item := i4 seller := u2 };

var i4 := Item{ name := "Item 4" };
var i3 := Item{ name := "Item 3" };
var i2 := Item{ name := "Item 2" };
var i1 := Item{ name := "Item 1" };

var u2 := User{ name := "User 2" };
var u1 := User{ name := "User 1" };*/

define page root(){
	<div id="a1">output("" + (from Auction)[0].id)</div>
	<div id="u1">output("" + (from User)[0].id)</div>
}

define page auctionOverview1() {
  for(a : Auction){
    navigate showAuction(a) { output(a.item) }
  }
}

define page auctionOverview2() {
  for(a : Auction){
    navigate showAuction(a) { output(a.item.name) }
  }
}

define page showAuction(a : Auction) {
    derive viewRows from a
}

define page conditionExtraction() {
  var stats : Statistics := HibernateUtilConfigured.getSessionFactory().getStatistics();
  init{
  stats.setStatisticsEnabled(true);
  }
  var entFetch : Long := stats.getEntityFetchCount();
  var entLoaded : Long := stats.getEntityLoadCount();
  for(b : Bid) {
    if(b.auction.item.name == "Item 1" && b.buyer.name == "User 2") {
      output(b)
      output(b.auction.seller.name)
    }
  } separated-by {<br />}
  <p id="entFetch">output(stats.getEntityFetchCount() - entFetch)</p>
  <p id="entLoaded">output(stats.getEntityLoadCount() - entLoaded)</p>
}

define page showProfile(u : User) {
  section {
    header { "Bid history" }
    for(b : Bid in u.bids) {
      output(b.auction.item.name)
      output(b.auction.seller.name)
      output(b.offer)
    } separated-by {<br />}
  }
  section {
    header { "Auction history" }
    for(a : Auction in u.auctions) {
      <p>
        output(a.item.name)
        <br />
        for(ab : Bid in a.bids) {
          output(ab.buyer.name)
          output(ab.offer)
        } separated-by {<br />}
      </p>
    }
  }
}

test queries {
  var d : WebDriver := FirefoxDriver();

  d.get(navigate(root()));
  var elem : WebElement := d.findElement(SelectBy.id("a1"));
  var a1 : Auction := Auction {};
  a1.id := UUID.fromString(elem.getText());
  elem := d.findElement(SelectBy.id("u1"));
  var u1 : User := User {};
  u1.id := UUID.fromString(elem.getText());

  d.get(navigate(auctionOverview1()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 1);

  d.get(navigate(auctionOverview2()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 1);

  d.get(navigate(showAuction(a1)) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 1);

  d.get(navigate(conditionExtraction()) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 1);
  elem := d.findElement(SelectBy.id("entFetch"));
  assert(elem.getText().parseInt() == 0);
  elem := d.findElement(SelectBy.id("entLoaded"));
  assert(elem.getText().parseInt() == 6);
  
  d.get(navigate(showProfile(u1)) + "?logsql");
  elem := d.findElement(SelectBy.id("sqllogcount"));
  assert(elem.getText().parseInt() == 2);

  d.close();
}
