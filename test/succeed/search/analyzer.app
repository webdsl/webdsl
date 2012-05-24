application test

section model

//A
entity SuperA {
    a :: String
    b :: Int
}
extend entity SuperA {
    c :: String (searchable(name = cNGram, analyzer = ngram)^4.0)
}
entity A : SuperA{
    d :: String (searchable)

    search mapping{
        a;
        a using no as aUntokenized;
        a using standard as aStandard;
        a using standard_no_stop as aNoStop;
        a using standard_custom_stop as aCustomStop;
        a as aTriGram using trigram;
        a as aAutocomplete using autocomplete_untokenized (autocomplete);
        a as aSnowball using snowballporter;
        a as aPhonetic using phonetic;
        c using standard_no_stop;
    }
}

//Analyzer definitions
default analyzer standard {
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
    token filter = StopFilter
}

analyzer standard_no_stop{
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
}

analyzer standard_custom_stop{
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
    token filter = StopFilter (words="analyzerfiles/stopwords.txt")
}

analyzer trigram{
    tokenizer = StandardTokenizer
    token filter = LowerCaseFilter
    token filter = StopFilter()
    token filter = NGramFilter(minGramSize = "3", maxGramSize = "3")
}

analyzer autocomplete_untokenized{
    tokenizer = KeywordTokenizer
    token filter = LowerCaseFilter
}

analyzer snowballporter{
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
    token filter = SnowballPorterFilter(language="English")
}

analyzer phonetic{
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
    token filter = PhoneticFilter(encoder = "RefinedSoundex")
}

define page root() {

    action test() {
        var x1 := searchA("x",0,10);
        var x2 := searchA("x",10);
        var x3 : List<A> := ASearcher().query("test").results();
    }

}