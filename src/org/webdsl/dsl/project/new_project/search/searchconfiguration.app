module search/searchconfiguration

section search analyzers

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

analyzer synonym{
	index{
		tokenizer = StandardTokenizer
		token filter = StandardFilter
		token filter = SynonymFilter(ignoreCase="true", expand="true", synonyms="analyzerfiles/synonyms.txt")
		token filter = LowerCaseFilter
		token filter = StopFilter (words="analyzerfiles/stopwords.txt")
	}
	query{
		tokenizer = StandardTokenizer
		token filter = StandardFilter
		token filter = LowerCaseFilter
		token filter = StopFilter (words="analyzerfiles/stopwords.txt")
	}
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