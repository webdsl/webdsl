package org.webdsl.search;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.spell.SpellChecker;
import org.apache.lucene.store.Directory;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.reader.ReaderProvider;
import org.hibernate.search.store.DirectoryProvider;

public class SearchSuggester {

	SearchFactory sf;

	public List<String> findSuggestions(SearchFactory sf, SearchQuery<?> sq, int maxSuggestionsPerFieldCount, List<String> fields, String toSuggestOn) {
		
		Map<String, List<String>> fieldSuggestionsMap = new LinkedHashMap<String, List<String>>();		
		this.sf = sf;
		
		for (String suggestedField : fields) {
			List<String> fieldSuggestions = findSuggestionsForField(sq,	toSuggestOn, maxSuggestionsPerFieldCount, suggestedField, true);
			fieldSuggestionsMap.put(suggestedField, fieldSuggestions);
		}

		return mergeSuggestions(maxSuggestionsPerFieldCount, fieldSuggestionsMap);
	}

	public List<String> findSuggestionsForField(SearchQuery<?> sq, String toSuggestOn, int maxSuggestionsCount, String suggestedField, boolean morePopular) {
		
		try {
			Directory dir = sq.spellDirectoryForField(suggestedField);
			final SpellChecker spellChecker = new SpellChecker(sq.spellDirectoryForField(suggestedField));

			// get the suggested words
			String[] words = toSuggestOn.split("\\s+");
			
			for (String word : words) {
				if (spellChecker.exist(word)) {
					// no need to include suggestions for that word
					// TODO in case of multiple-fields suggestion that word
					// should be excluded from suggestion in other fields
					continue;
				}				
				String[] suggestions = null;
				if (!morePopular) {
					suggestions = spellChecker.suggestSimilar(word,	maxSuggestionsCount);
				} else {
					// use more-popular approach for suggestions
					suggestions = findPopularSuggestions(sq, suggestedField, maxSuggestionsCount, word, spellChecker);
				}
				return Arrays.asList(suggestions);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}

		return Collections.emptyList();
	}

	private String[] findPopularSuggestions(SearchQuery<?> sq, String suggestedField, int maxSuggestionsCount, String word, SpellChecker spellChecker) throws IOException {

		String[] suggestions;
		IndexReader fieldIR = null;
		
		try{
			fieldIR = getIndexReader(sq.entityClass);
			suggestions = spellChecker.suggestSimilar(word, maxSuggestionsCount, fieldIR, suggestedField, true);
		} finally{
			if(fieldIR != null)
			sf.getReaderProvider().closeReader(fieldIR);
		}

		return suggestions;
	}

	private List<String> mergeSuggestions(int suggestionNumber, Map<String, List<String>> fieldSuggestionsMap) {
		
		LinkedHashSet<String> suggestionsSet = new LinkedHashSet<String>();
		
		for (int suggestionPosition = 0; suggestionPosition <= suggestionNumber; suggestionPosition++) {
			for (Map.Entry<String, List<String>> fieldSuggestionsEntry : fieldSuggestionsMap.entrySet()) {
				List<String> suggestedTerms = fieldSuggestionsEntry.getValue();
				if (suggestedTerms.size() > suggestionPosition) {
					String suggestion = suggestedTerms.get(suggestionPosition);
					suggestionsSet.add(suggestion);
				}
			}
		}
		return new ArrayList<String>(suggestionsSet);
	}

	private IndexReader getIndexReader(Class<?> entityClass) {
		ReaderProvider readerProvider = sf.getReaderProvider();

		DirectoryProvider[] directoryProviders = sf.getDirectoryProviders(entityClass);
		return readerProvider.openReader(directoryProviders);
	}
}