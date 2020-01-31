application test

section model

entity Movie {
    title  :: String
    abstract :: Text
    year   :: Int
    genres -> Set<Genre>

    search mapping{
       title (autocomplete)
       abstract
       year
       genres
    }
}

entity User {
    name :: String
    credit :: Int
    search mapping{
        name
        credit
    }
}

entity Genre{
    name   :: String
    desc   : String
    movies : Set<Movie> (inverse = Movie.genres)

    search mapping{
        name
        desc
    }
}
entity Material{
    name :: String
    alias :: String
    desc : Text
    search mapping{
        name
        alias
        desc
    }
    function getSearcher() : Searcher{
        return search Material;
    }
}

// Above mappings should result in each entity to be indexed and static search functions created.
define page root() {

    action test() {
        var q  := "horror";
        var item := Material{name:="a" alias:="b" desc:="a b c"};
        
        var x0 := search Movie matching +(title,abstract: "hello") -(title:"goodbye");

        //Find Movie entities that match "hello" in title or abstract,
        //but doesnt match "goodbye" in any of the default search fields
        var x1 := search Movie matching title^10.0,abstract^100.0: +"hello" -"goodbye";

        //Find Movie entities that match "hello" in title or abstract,
        //but doesnt match "goodbye" in title or abstract
        var x2 := search Movie matching title,abstract: (+"hello" -"goodbye");

        //Find Movie entities that match "hello", but doesnt match "goodbye" in
        //any of the default search fields
        var x3 := search Movie matching +"hello" -"goodbye";

        //Find materials with (name "metal peroxide") OR
        //( 'some material that has "metal" in desc AND
        //  "peroxide" in title AND OPTIONALLY
        //  (a name or alias with "mp" but NOT "magnesium") )
        var x4 := search Material
                  matching ( desc:+"metal" name:+"peroxide"
                             name,alias:("mp" -"magnesium")
                           ) name:"metal peroxide";

        var x5 := search User matching credit: (-200);

        //modify x1 searcher to exclude movies with year 2001
        ~x1 matching -(year:2001);
        ~x1 matching year:-(2001);

        var x6 := search Movie order by year asc, title desc
                 with filters year:2000, genres.name:q
                 with facets genre.name(20), title([* to "A"},["A" to "L"],["M" to "Q"],["Q" to "Z"],{"Z" to *]);
        var x7 := search Movie matching +(title: (-q +"island") abstract:-"human");

        var x8 := search Movie matching +item.name;

        //x9 and x10 have the same constraints
        var x9  := search Movie matching genres.name^2.0: +item.name matching genres.desc: +item.desc limit 10000;
        var x10 := search Movie matching genres.name^2.0: +item.name genres.desc: +item.desc limit 10000;

        var index := 3;

        var x11 := search   Movie
                    matching title: +item.alias
                    with facets name(3)
                    offset (index*100) limit 100
                    order by year desc;

        var x12 := name facets from x11;
        var x13 := count from x1;
        var x14 := field facets from item.getSearcher();
        var x15 := field facets from search Movie matching +item.name -q;

        var x16 := field facets from x9 == [Facet()];
        var x17 := Movie completions matching title:"Tra" similarity 5 / 11 != null;

        var x18 := search Movie matching q~100 with filter year:2001 with facets year(40) [strict matching];
        var x19 := search Movie matching q~100 with filter year:2001 with facets year([1990 to 2000],[2001 to 2010],[2010 to *]) [strict matching];
        
        var highlighted := highlight title: "some text" from x1;
        var highlighted1 := highlight desc: item.desc from x4 with tags ("<span class=\"HL\">","</span>");

    }
}
