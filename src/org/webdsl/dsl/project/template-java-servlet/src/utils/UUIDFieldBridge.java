package utils;

import java.util.UUID;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.hibernate.search.bridge.LuceneOptions;
import org.hibernate.search.bridge.TwoWayFieldBridge;

public class UUIDFieldBridge implements TwoWayFieldBridge {
	public void set(String name, Object value, Document doc, LuceneOptions options) {
		Field field = new Field(name, value.toString(), options.getStore(), options.getIndex(), options.getTermVector());
		field.setBoost(options.getBoost());
		doc.add(field);
	}

	public Object get(String name, Document doc) {
		return UUID.fromString(doc.get(name));
	}

	public String objectToString(Object value) {
		return value.toString();
	}
}
