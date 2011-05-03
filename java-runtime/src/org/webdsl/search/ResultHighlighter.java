package org.webdsl.search;
import java.io.IOException;
import java.io.StringReader;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;

public class ResultHighlighter {
	
	public static String highlight(SearchQuery<?> sq, String field, String text){
		
		String result;
		TokenStream tokenStream;
		Highlighter highlighter;
		Query rewritten = null;
		IndexReader ir = sq.getReader();
		text = text.replaceAll("\"", " ");
		try {
			rewritten = sq.luceneQuery.rewrite(ir);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if(rewritten != null){
			highlighter = new Highlighter( new QueryScorer( rewritten ) );
			
			highlighter.setTextFragmenter(new SimpleFragmenter(80));
			tokenStream = sq.analyzer.tokenStream(field, new StringReader( text ) );			
			
			try {
				result = highlighter.getBestFragments(tokenStream, text, 3, "...");
			} catch (IOException e) {
				result = "";
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InvalidTokenOffsetsException e) {
				result = "";
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
			result = "";
		
		sq.closeReader(ir);		
		
		return result;
	}

}
