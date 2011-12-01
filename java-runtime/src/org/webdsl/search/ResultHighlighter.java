package org.webdsl.search;
import java.io.IOException;
import java.io.StringReader;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;

public class ResultHighlighter {
	
	public static String highlight(AbstractEntitySearcher<?,?> sq, String field, String text, String preTag, String postTag, int fragments, int fragmentLength, String separator){
//		long tmp = System.currentTimeMillis();
		String result = "";
		TokenStream tokenStream;
		Highlighter highlighter;
		IndexReader ir = null;
		Query rewritten = null;
		try {
			ir = sq.getReader();
			rewritten = sq.luceneQueryNoFacetFilters.rewrite(ir);
		
			
			if(rewritten != null){
				highlighter = new Highlighter(new SimpleHTMLFormatter(preTag, postTag), new QueryScorer( rewritten ) );
				
				highlighter.setTextFragmenter(new SimpleFragmenter(fragmentLength));
				tokenStream = sq.analyzer.tokenStream(field, new StringReader( text ) );			
				
				try {
					result = highlighter.getBestFragments(tokenStream, text, fragments, separator);
					
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
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			sq.closeReader(ir);
		}
//		System.out.println("highlighting took:" + (System.currentTimeMillis() - tmp) + "ms");
		return result;
		
	}
	
	public static String highlight(AbstractEntitySearcher<?, ?> sq, String field, String text){				
		return highlight(sq, field, text, "<B>", "</B>", 3, 80, " ...");
	}
	public static String highlight(AbstractEntitySearcher<?, ?> sq, String field, String text, String preTag, String postTag){				
		return highlight(sq, field, text, preTag, postTag, 3, 80, " ...");
	}
}