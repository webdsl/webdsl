application test

section model

entity Movie {
    title  :: String
    abstract :: Text
    year   :: Int
    genres -> Set<Genre>

    search mapping{
       title
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
    desc   :: String
    movies -> Set<Movie> (inverse = Movie.genres)

    search mapping{
        name
        desc
    }
}
entity Material{
    name :: String
    alias :: String
    desc :: Text
    search mapping{
        name
        alias
        desc
    }
}

// Above mappings should result in each entity to be indexed and static search functions created.
define page root() {

    action test() {
        var q  := "horror";
        var item := Material{name:="a" alias:="b" desc:="a b c"};

        //Find Movie entities that match "hello" in title or abstract, but doesnt match "goodbye" in any of the default search fields
        var x1 := search Movie matching title,abstract: +"hello" -"goodbye";

        //Find Movie entities that match "hello" in title or abstract, but doesnt match "goodbye" in title or abstract
        var x2 := search Movie matching title,abstract: (+"hello" -"goodbye");

        //Find Movie entities that match "hello" but doesnt match "goodbye" in any of the default search fields
        var x3 := search Movie matching +"hello" -"goodbye";

        //Find materials with (name "metal peroxide") OR ('some material that has "metal" in desc AND "peroxide" in title AND OPTIONALLY (a name or alias with "mp" but NOT "magnesium"))
        var x4 := search Material matching (desc:+"metal" title:+"peroxide" name,alias:("mp" -"magnesium") ) name:"metal peroxide";

        var x5 := search User matching credit: (-200);

        //modify x1 searcher to exclude movies with year 2001
        ~x1 matching -(year:2001);
        ~x1 matching year:-(2001);

        var x6 := search Movie order by year asc, title desc
                 with filters year:2000, genre.name:q
                 with facets (genre.name,20), (title: [ to "A"},["A" to "L"],["M" to "Q"],["Q" to "Z"],{"Z" to ]);
        var x7 := search Movie matching +(title: (-q +"island") description:-"human");

        var x8 := search Movie matching +item.name;
        var x9 := search Movie
                      matching genres.name: +item.name
                      matching genres.desc: +item.desc.replace(" ","\\ ")
                      limit 10000;

        var index := 3;

        var x10 := search   Movie
                    matching name: +item.alias
                    offset (index*100) limit 100
                    order by year desc;


    }
}
