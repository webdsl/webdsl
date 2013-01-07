package org.webdsl.search;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.Field.Index;
import org.apache.lucene.document.Field.Store;
import org.hibernate.search.bridge.FieldBridge;
import org.hibernate.search.bridge.LuceneOptions;

public class WebDSLDynamicFieldBridge implements FieldBridge {
    
	@Override
    public void set(
        String name, Object value, Document document, LuceneOptions luceneOptions) {
		for(DynamicSearchField dsf : ( (DynamicSearchFields) value).getDynamicSearchFields_()){
			document.add( new Field( dsf.fieldName, dsf.fieldValue, Store.NO,
		            Index.NOT_ANALYZED, luceneOptions.getTermVector() ) );
		}
   }

}