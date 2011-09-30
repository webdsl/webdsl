module search/searchconfiguration

section search analyzers

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

analyzer synonym{
	index{
		tokenizer = StandardTokenizer
		tokenfilter = StandardFilter
		tokenfilter = SynonymFilter(ignoreCase="true", expand="true", synonyms="analyzerfiles/synonyms.txt")
		tokenfilter = LowerCaseFilter
		tokenfilter = StopFilter (words="analyzerfiles/stopwords.txt")
	}
	query{
		tokenizer = StandardTokenizer
		tokenfilter = StandardFilter
		tokenfilter = LowerCaseFilter
		tokenfilter = StopFilter (words="analyzerfiles/stopwords.txt")
	}
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