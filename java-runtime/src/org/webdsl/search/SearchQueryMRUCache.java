package org.webdsl.search;

import java.util.LinkedHashMap;
import java.util.Map;


public class SearchQueryMRUCache {
	
	private static SearchQueryMRUCache ref;
	private final int size = 1000;
	private final CacheLinkedHashMap<String, SearchQuery<?>> cache;

	private SearchQueryMRUCache()
    {
		cache = new CacheLinkedHashMap<String, SearchQuery<?>>( size );
    }
	
	public Object getObject(String key){
		Object value;
		synchronized ( this ) {
			value = cache.get(key);
		}
		return value;
	}
	
	public String putObject(String key, SearchQuery<?> value){
		synchronized ( this ) {
			cache.put(key, value);
		}
		return key;
	}
	
	
	public static synchronized SearchQueryMRUCache getInstance()
    {
      if (ref == null)
          ref = new SearchQueryMRUCache();
      return ref;
    }
	
    private static class CacheLinkedHashMap<K, V> extends LinkedHashMap<K, V> {
        /**
		 * 
		 */
		private static final long serialVersionUID = 1L;
		private final int maxSize;

        public CacheLinkedHashMap ( int maxSize ) {
            // default load factor is 0.75
            super ( 0 , 0.75f , true ) ;
            this .maxSize = maxSize;
        }

        protected boolean removeEldestEntry ( Map.Entry<K,V> eldest ) {
            return size () > maxSize;
        }
    }

    
}
