package org.webdsl.search;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.search.BooleanClause;
import org.apache.lucene.search.BooleanClause.Occur;
import org.apache.lucene.search.Query;
import org.apache.lucene.util.Version;

/**
 * @author Elmer van Chastelet
 * 
 * Special implementation of the MultiFieldQueryParser (based on Lucene 3.1.0 version of this class).
 * It treats a special case, namely when terms are filtered out for some(!) of the fields (when using
 * a per field analyzer wrapper, and not every field analyzer use a stopword filter), and the default
 * operator is set to AND. In that case, the parse method creates 2 sub queries, and takes the union
 * of these. One query will be parsed using the normal implementation in MultiFieldQueryParser, the
 * other query will not contain the clauses for terms that are filtered out for at least 1 field, but
 * not all fields.
 * 
 * Example where fields 'title' and 'description' use a stopword filter:
 * Query to parse: the best project
 * parsed:
 * (
 *  +(title:best description:best authors.name:best)
 *  +(title:project description:project authors.name:project)
 * )(
 *  +(authors.name:the)
 *  +(title:best description:best authors.name:best)
 *  +(title:project description:project authors.name:project)
 * )
 * 
 */
public class SpecialMultiFieldQueryParser extends MultiFieldQueryParser {
	private boolean defaultAndnStopword = false;
	private boolean inQueryFix = false;

	public SpecialMultiFieldQueryParser(Version matchVersion, String[] fields, Analyzer analyzer) {
		super(matchVersion, fields, analyzer);
	}
	
	public SpecialMultiFieldQueryParser(Version matchVersion, String[] fields, Analyzer analyzer,
			Map<String, Float> boosts) {
		super(matchVersion, fields, analyzer, boosts);
	}

	@Override
	protected org.apache.lucene.search.Query getFieldQuery(String field, String queryText, boolean quoted)
			throws ParseException {
		if(inQueryFix)
			return super.getFieldQuery(field, queryText, quoted);
		
	    if (field == null) {
	        List<BooleanClause> clauses = new ArrayList<BooleanClause>();
	        for (int i = 0; i < fields.length; i++) {
	          Query q = super.getFieldQuery(fields[i], queryText, quoted);
	          if (q != null) {
	            //If the user passes a map of boosts
	            if (boosts != null) {
	              //Get the boost from the map and apply them
	              Float boost = boosts.get(fields[i]);
	              if (boost != null) {
	                q.setBoost(boost.floatValue());
	              }
	            }
	            clauses.add(new BooleanClause(q, BooleanClause.Occur.SHOULD));
	          }
	        }
	        if (getDefaultOperator() == AND_OPERATOR && clauses.size() != fields.length){
	        	// happens for stopwords, special treatment needed in case of AND operator
	        	defaultAndnStopword = true;
	        	return null;
	        }
	        
	        if (clauses.size() == 0)  // happens for stopwords, if default operator is OR
	          return null;
	        
	        return getBooleanQuery(clauses, true);
	      }
	      Query q = super.getFieldQuery(field, queryText, quoted);
	      return q;
	}

	@Override
	public Query parse(String query) throws ParseException{
		Query q = super.parse(query);
		if(defaultAndnStopword){
			inQueryFix = true;
			Query fix = super.parse(query);
			List<BooleanClause> clauses = new ArrayList<BooleanClause>();
			clauses.add(new BooleanClause(q,Occur.SHOULD));
			clauses.add(new BooleanClause(fix,Occur.SHOULD));
			return getBooleanQuery(clauses);
		}
		return q;
			
		
	}
}
