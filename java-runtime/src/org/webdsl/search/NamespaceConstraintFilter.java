package org.webdsl.search;
	      
import org.apache.lucene.search.Filter;
import org.apache.lucene.search.QueryWrapperFilter;
import org.hibernate.search.filter.CachingWrapperFilter;
import org.hibernate.search.filter.StandardFilterKey;
   
	public class NamespaceConstraintFilter{
  		private String namespace;

	
		@org.hibernate.search.annotations.Factory
		public Filter buildFilter(){
			Filter filter = new QueryWrapperFilter( SearchHelper.namespaceQuery(namespace) );
			filter = new CachingWrapperFilter( filter );
			return filter;
		}
				
		public void setNamespace(String value){
			this.namespace = value;
		}
	
		@org.hibernate.search.annotations.Key
		public org.hibernate.search.filter.FilterKey getKey() {
	
			StandardFilterKey key = new StandardFilterKey();
			key.addParameter(namespace);
			return key;	
		}

	} 