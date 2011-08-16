package org.webdsl.search;
	      
	import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.index.Term;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.Filter;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.QueryWrapperFilter;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.util.Version;
import org.hibernate.search.filter.CachingWrapperFilter;
import org.hibernate.search.filter.StandardFilterKey;
   
	public class FieldConstraintFilter{
  		private String field, value;
  		private Analyzer analyzer;
  		private boolean allowLuceneSyntax;
	
		@org.hibernate.search.annotations.Factory
		public Filter buildFilter(){
			QueryParser qp = new QueryParser(Version.LUCENE_CURRENT,field, analyzer);
			Query q;
			try {
				if(allowLuceneSyntax)
					q = qp.parse(value);
				else
					q = qp.parse(QueryParser.escape(value));
			} catch (ParseException e) {
				System.out.println("Error while parsing query in field filter: ");
				e.printStackTrace();
				q = new TermQuery(new Term(field, value));
			}
			Filter filter = new QueryWrapperFilter(q);
			filter = new CachingWrapperFilter( filter );
			return filter;
		}
		
		public void setAnalyzer(Analyzer analyzer) {
			this.analyzer = analyzer;
		}
		
		public void setField(String field) {
			this.field = field;
		}
		
		public void setValue(String value){
			this.value = value;
		}
		
		public void setAllowLuceneSyntax (boolean allowLuceneSyntax){
			this.allowLuceneSyntax = allowLuceneSyntax;
		}
	
		@org.hibernate.search.annotations.Key
		public org.hibernate.search.filter.FilterKey getKey() {
	
			StandardFilterKey key = new StandardFilterKey();
			key.addParameter(field);
			key.addParameter(value);	
			key.addParameter(allowLuceneSyntax);
			return key;	
		}

	} 