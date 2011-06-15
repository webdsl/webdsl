module search/searchconfiguration

section search analyzers

default analyzer standard{
	tokenizer = StandardTokenizer
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter
	tokenfilter = StopFilter //(words="stopwords.txt")
}

analyzer standardNoStopFilter{
	tokenizer = StandardTokenizer
	tokenfilter = StandardFilter
	tokenfilter = LowerCaseFilter
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