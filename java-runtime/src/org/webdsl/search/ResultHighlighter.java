package org.webdsl.search;
import java.io.IOException;
import java.io.StringReader;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.highlight.Formatter;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;
import org.apache.lucene.search.highlight.TokenGroup;

public class ResultHighlighter {
	
	public static String highlight(AbstractEntitySearcher<?> sq, String field, String text, String preTag, String postTag){
		
		String result;
		TokenStream tokenStream;
		Highlighter highlighter;
		Query rewritten = null;
		IndexReader ir = sq.getReader();

		try {
			rewritten = sq.luceneQuery.rewrite(ir);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		if(rewritten != null){
			highlighter = new Highlighter(new SimpleHTMLFormatter(preTag, postTag), new QueryScorer( rewritten ) );
			
			highlighter.setTextFragmenter(new SimpleFragmenter(80));
			tokenStream = sq.analyzer.tokenStream(field, new StringReader( text ) );			
			
			try {
				result = highlighter.getBestFragments(tokenStream, text, 3, " ...");
			} catch (IOException e) {
				result = "";
				e.printStackTrace();
			} catch (InvalidTokenOffsetsException e) {
				result = "";
				e.printStackTrace();
			}
		}
		else
			result = "";
		
		sq.closeReader(ir);
		
		return result;
		
	}
	
	public static String highlight(AbstractEntitySearcher<?> sq, String field, String text){				
		return highlight(sq, field, text, "<B>", "</B>");
	}
}