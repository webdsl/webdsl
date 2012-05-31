package org.webdsl.search;

import org.apache.lucene.index.Term;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;

public class SearchHelper {
	
	public final static String NAMESPACEFIELD = "_WebDSLNamespaceID_";
	
	public static int firstIndexLink(int current, int total, int indexLinks){
		int beforeCenter = (int) Math.ceil(((double)indexLinks) / 2) - 1;
		return Math.max(1, Math.min(current-beforeCenter, total-indexLinks+1));
	}
	
	public static int lastIndexLink (int current, int total, int indexLinks){
		int afterCenter = (int) Math.floor(((double)indexLinks) / 2);
		return Math.min(total, Math.max(current + afterCenter,indexLinks));
	}
	
	public static Query namespaceQuery(String namespace){
		return new TermQuery(new Term(NAMESPACEFIELD, namespace));
	}
}
