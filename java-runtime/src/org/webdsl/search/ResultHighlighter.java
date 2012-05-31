package org.webdsl.search;
import java.io.IOException;
import java.io.StringReader;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.InvalidTokenOffsetsException;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleFragmenter;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;

public class ResultHighlighter {

    public static String highlight( IndexReader ir, Analyzer an, Query query,  String field, String text, String preTag, String postTag, int fragments, int fragmentLength, String separator){
//        long tmp = System.currentTimeMillis();
        String result = "";
        TokenStream tokenStream;
        Highlighter highlighter;

        if(query != null){
            QueryScorer qs = new QueryScorer(query, ir, field);
            qs.setExpandMultiTermQuery(true);
            highlighter = new Highlighter(new SimpleHTMLFormatter(preTag, postTag), qs );
            highlighter.setTextFragmenter(new SimpleFragmenter(fragmentLength));
            tokenStream = an.tokenStream(field, new StringReader( text ) );
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
//        System.out.println("highlighting took:" + (System.currentTimeMillis() - tmp) + "ms");
        return result;

    }
}