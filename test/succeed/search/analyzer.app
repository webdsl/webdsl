application test

section model

//A
entity SuperA {
	a :: String
	b :: Int
}
extend entity SuperA {
	c :: String (searchable(name = cNGram, analyzer = ngram)*4.0)
}
entity A : SuperA{
	d :: String (searchable)
	
	searchmapping{
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
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter
	tokenfilter = StopFilter
}  

analyzer standard_no_stop{
	tokenizer = StandardTokenizer
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter
}

analyzer standard_custom_stop{
	tokenizer = StandardTokenizer
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter
	tokenfilter = StopFilter (words="analyzerfiles/stopwords.txt")
}

analyzer trigram{
	tokenizer = StandardTokenizer
	tokenfilter = LowerCaseFilter
	tokenfilter = StopFilter()
	tokenfilter = NGramFilter(minGramSize = "3", maxGramSize = "3")
}

analyzer autocomplete_untokenized{
	tokenizer = KeywordTokenizer
	tokenfilter = LowerCaseFilter
}

analyzer snowballporter{
	tokenizer = StandardTokenizer
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter	
	tokenfilter = SnowballPorterFilter(language="English")
}

analyzer phonetic{
	tokenizer = StandardTokenizer
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter
	tokenfilter = PhoneticFilter(encoder = "RefinedSoundex")
}

define page root() {
	
	action test() {
		var x1 := searchA("x",0,10);
		var x2 := searchA("x",10);
		var x3 : List<A> := ASearchQuery().query("test").list();
	}
		
}