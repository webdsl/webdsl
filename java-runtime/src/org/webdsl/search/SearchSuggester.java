package org.webdsl.search;

import java.io.File;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
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
import org.apache.lucene.store.FSDirectory;
import org.hibernate.search.SearchFactory;
import org.hibernate.search.reader.ReaderProvider;

import utils.ThreadLocalPage;

public class SearchSuggester {

	private static SearchFactory sf;
	static {
		sf = org.hibernate.search.Search.getFullTextSession(ThreadLocalPage.get().getHibSession())
				.getSearchFactory();
	}

	public static ArrayList<String> findSpellSuggestions(Class<?> entityClass, String baseDir, List<String> fields,
			int maxSuggestionsPerFieldCount, float accuracy, String toSuggestOn) {

		Map<String, List<String>> fieldSuggestionsMap = new LinkedHashMap<String, List<String>>();

		for (String suggestedField : fields) {
			List<String> fieldSuggestions = findSpellSuggestionsForField(entityClass, baseDir, suggestedField,
					maxSuggestionsPerFieldCount, accuracy, true, toSuggestOn);
			fieldSuggestionsMap.put(suggestedField, fieldSuggestions);
		}

		return mergeSuggestions(maxSuggestionsPerFieldCount, fieldSuggestionsMap);
	}

	@SuppressWarnings("deprecation")
	public static ArrayList<String> findSpellSuggestionsForField(Class<?> entityClass, String baseDir,
			String suggestedField, int maxSuggestionCount, float accuracy, boolean morePopular,
			String toSuggestOn) {
		
		if (toSuggestOn == null || toSuggestOn.isEmpty())
			return new ArrayList<String>();

		SpellChecker spellChecker = null;
		IndexReader fieldIR = null;
		boolean hasSuggestions = false;

		try {
			spellChecker = new SpellChecker(FSDirectory.open(new File(baseDir+suggestedField)));

			spellChecker.setAccuracy(accuracy);

			Analyzer analyzer = sf.getAnalyzer(entityClass);
			TokenStream tokenStream = analyzer.tokenStream(suggestedField, new StringReader(
					toSuggestOn));
			CharTermAttributeImpl ta = (CharTermAttributeImpl) tokenStream
					.addAttribute(CharTermAttribute.class);

			ArrayList<String[]> allSuggestions = new ArrayList<String[]>();

			String word;
			String[] suggestions;
			while (tokenStream.incrementToken()) {
				word = ta.term();
				suggestions = null;
				if (spellChecker.exist(word)) {/* do nothing */
				} else if (!morePopular) {
					suggestions = spellChecker.suggestSimilar(word, maxSuggestionCount);
				} else {
					if (fieldIR == null)
						fieldIR = getIndexReader(entityClass);
					suggestions = spellChecker.suggestSimilar(word, maxSuggestionCount, fieldIR,
							suggestedField, true);
				}

				if (suggestions == null || suggestions.length == 0)
					suggestions = new String[] { word };
				else
					hasSuggestions = true;

				allSuggestions.add(suggestions);
			}

			if (!hasSuggestions)
				// if no suggestions were found, return empty list
				return new ArrayList<String>();
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

		return new ArrayList<String>();
	}

	private static IndexReader getIndexReader(Class<?> entityClass) {
		ReaderProvider readerProvider = sf.getReaderProvider();
		return readerProvider.openReader(sf.getDirectoryProviders(entityClass));
	}

	public static ArrayList<String> findAutoCompletions(Class<?> entityClass, String baseDir, List<String> fields,
			int maxSuggestionsPerFieldCount, String toSuggestOn) {

		Map<String, List<String>> fieldSuggestionsMap = new LinkedHashMap<String, List<String>>();

		for (String suggestedField : fields) {
			List<String> fieldSuggestions = findAutoCompletionsForField(entityClass, baseDir, suggestedField,
					maxSuggestionsPerFieldCount, toSuggestOn);
			fieldSuggestionsMap.put(suggestedField, fieldSuggestions);
		}

		return mergeSuggestions(maxSuggestionsPerFieldCount, fieldSuggestionsMap);
	}

	@SuppressWarnings("deprecation")
	public static ArrayList<String> findAutoCompletionsForField(Class<?> entityClass, String baseDir,
			String suggestedField, int maxSuggestionCount, String toSuggestOn) {

		if (toSuggestOn == null || toSuggestOn.isEmpty())
			return new ArrayList<String>();
		
		AutoCompleter autoCompleter = null;

		try {
			autoCompleter = new AutoCompleter(FSDirectory.open(new File(baseDir+suggestedField)));
			Analyzer analyzer = sf.getAnalyzer(entityClass);
			TokenStream tokenStream = analyzer.tokenStream(suggestedField, new StringReader(
					toSuggestOn));
			CharTermAttributeImpl ta = (CharTermAttributeImpl) tokenStream
					.addAttribute(CharTermAttribute.class);

			boolean dontstop = tokenStream.incrementToken();
			StringBuilder prefixSb = new StringBuilder();
			String word = "";
			
			while (dontstop){ //eat up all tokens
				word = ta.term();
				dontstop = tokenStream.incrementToken();
				if(dontstop)
					prefixSb.append(word + " ");
			}
		
			String prefix = prefixSb.toString();
			
			String[] suggestions = autoCompleter.suggestSimilar(word, maxSuggestionCount);
				
			
			ArrayList<String> allSuggestions = new ArrayList<String>();
			
			if (suggestions == null || suggestions.length == 0){
					return allSuggestions;
			}		
						
			for(int i = 0; i < suggestions.length; i++){
				allSuggestions.add(prefix + suggestions[i]);
			}
			return allSuggestions;

		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (autoCompleter != null)
				try {
					autoCompleter.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return new ArrayList<String>();
	}

	// fill in suggested words between correct/existing words
	private static ArrayList<String> formSuggestions(int maxSuggestionCount,
			ArrayList<String[]> allSuggestions) {
		
		ArrayList<String> toReturn = new ArrayList<String>();
		
		if (allSuggestions.isEmpty())
			return toReturn;
		
		int maxSuggestions = 0; 
		for (String[] strings : allSuggestions)
			maxSuggestions = maxSuggestions * strings.length; 
		maxSuggestionCount = Math.min(maxSuggestionCount, maxSuggestions);
		
		int pos;
		String suggestion;

		for (int i = 0; i < maxSuggestionCount; i++) {
			suggestion = "";
			for (String[] sugArray : allSuggestions) {
					pos = i % sugArray.length;
				suggestion += sugArray[pos] + " ";
			}
			toReturn.add(suggestion.trim());
		}
		return toReturn;
	}

	private static ArrayList<String> mergeSuggestions(int suggestionNumber,
			Map<String, List<String>> fieldSuggestionsMap) {

		LinkedHashSet<String> suggestionsSet = new LinkedHashSet<String>();

//		for (int suggestionPosition = 0; suggestionPosition <= suggestionNumber; suggestionPosition++) {
//			for (Map.Entry<String, List<String>> fieldSuggestionsEntry : fieldSuggestionsMap
//					.entrySet()) {
//				List<String> suggestedTerms = fieldSuggestionsEntry.getValue();
//				if (suggestedTerms.size() > suggestionPosition) {
//					String suggestion = suggestedTerms.get(suggestionPosition);
//					suggestionsSet.add(suggestion);
//				}
//			}
//		}
//		
		for(Map.Entry<String, List<String>> fieldSuggestionsEntry : fieldSuggestionsMap.entrySet()){
			for (String suggestion : fieldSuggestionsEntry.getValue()) {
				suggestionsSet.add(suggestion);
				suggestionNumber--;
				if(suggestionNumber < 1)
					return new ArrayList<String>(suggestionsSet);
			}
		}
		return new ArrayList<String>(suggestionsSet);
	}

}