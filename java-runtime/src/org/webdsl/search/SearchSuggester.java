package org.webdsl.search;

import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.apache.lucene.analysis.tokenattributes.CharTermAttributeImpl;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.spell.SpellChecker;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.reader.ReaderProvider;

import utils.ThreadLocalPage;

public class SearchSuggester {

	private static SearchFactory sf;
	static {
		sf = org.hibernate.search.Search.getFullTextSession(
				ThreadLocalPage.get().getHibSession()).getSearchFactory();
	}

	public static List<String> findSuggestions(SearchQuery<?> sq,
			int maxSuggestionsPerFieldCount, List<String> fields,
			String toSuggestOn) {

		Map<String, List<String>> fieldSuggestionsMap = new LinkedHashMap<String, List<String>>();

		for (String suggestedField : fields) {
			List<String> fieldSuggestions = findSuggestionsForField(sq,
					toSuggestOn, maxSuggestionsPerFieldCount, suggestedField,
					true);
			fieldSuggestionsMap.put(suggestedField, fieldSuggestions);
		}

		return mergeSuggestions(maxSuggestionsPerFieldCount,
				fieldSuggestionsMap);
	}

	// @SuppressWarnings("deprecation")
	public static List<String> findSuggestionsForField(SearchQuery<?> sq,
			String toSuggestOn, int maxSuggestionCount, String suggestedField,
			boolean morePopular) {

		SpellChecker spellChecker = null;
		IndexReader fieldIR = null;
		boolean hasSuggestions = false;
		String[] suggestions;
		String word;

		try {
			Directory dir = FSDirectory.open(sq
					.spellDirectoryForField(suggestedField));
			spellChecker = new SpellChecker(dir);
			Analyzer analyzer = sf.getAnalyzer(sq.entityClass);
			TokenStream tokenStream = analyzer.tokenStream(suggestedField,
					new StringReader(toSuggestOn));
			CharTermAttributeImpl ta = (CharTermAttributeImpl) tokenStream
					.addAttribute(CharTermAttribute.class);

			ArrayList<String[]> allSuggestions = new ArrayList<String[]>();

			while (tokenStream.incrementToken()) {
				word = ta.term();
				suggestions = null;
				if (spellChecker.exist(word)) {/* do nothing */
				} else if (!morePopular) {
					suggestions = spellChecker.suggestSimilar(word,
							maxSuggestionCount);
				} else {
					if (fieldIR == null)
						fieldIR = getIndexReader(sq.entityClass);
					suggestions = spellChecker.suggestSimilar(word,
							maxSuggestionCount, fieldIR, suggestedField, true);
				}

				if (suggestions == null || suggestions.length == 0)
					suggestions = new String[] { word };
				else
					hasSuggestions = true;

				allSuggestions.add(suggestions);
			}

			if (!hasSuggestions)
				// if no suggestions were found, return empty list
				return Collections.emptyList();
			else
				return formSuggestions(maxSuggestionCount, allSuggestions);

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (fieldIR != null)
				sf.getReaderProvider().closeReader(fieldIR);
			if (spellChecker != null)
				try {
					spellChecker.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}

		return Collections.emptyList();
	}

	// fill in suggested words between correct/existing words
	private static ArrayList<String> formSuggestions(int maxSuggestionCount,
			ArrayList<String[]> allSuggestions) {
		int pos;
		String suggestion;
		ArrayList<String> toReturn = new ArrayList<String>();

		for (int i = 0; i < maxSuggestionCount; i++) {
			suggestion = "";
			for (String[] sugArray : allSuggestions) {
				if (sugArray.length <= i)
					pos = 0;
				else
					pos = i;
				suggestion += sugArray[pos] + " ";
			}
			toReturn.add(suggestion.trim());
		}
		return toReturn;
	}

	private static IndexReader getIndexReader(Class<?> entityClass) {
		ReaderProvider readerProvider = sf.getReaderProvider();
		return readerProvider.openReader(sf.getDirectoryProviders(entityClass));
	}

	private static List<String> mergeSuggestions(int suggestionNumber,
			Map<String, List<String>> fieldSuggestionsMap) {

		LinkedHashSet<String> suggestionsSet = new LinkedHashSet<String>();

		for (int suggestionPosition = 0; suggestionPosition <= suggestionNumber; suggestionPosition++) {
			for (Map.Entry<String, List<String>> fieldSuggestionsEntry : fieldSuggestionsMap
					.entrySet()) {
				List<String> suggestedTerms = fieldSuggestionsEntry.getValue();
				if (suggestedTerms.size() > suggestionPosition) {
					String suggestion = suggestedTerms.get(suggestionPosition);
					suggestionsSet.add(suggestion);
				}
			}
		}
		return new ArrayList<String>(suggestionsSet);
	}
}