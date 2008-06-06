package org.webdsl.tools.strategoxt;

import java.util.WeakHashMap;

/**
 * An object-identity-based weak hash map.
 *
 * @author Lennart Kats <lennart add lclnet.nl>
 */
public class IdentityWeakHashMap<K,V> {
	private WeakHashMap<IdentityWrapper<K>, V> map =
		new WeakHashMap<IdentityWrapper<K>, V>();
	
	private class IdentityWrapper<T> {
		private T wrapped;
		
		IdentityWrapper(T wrapped) {
			this.wrapped = wrapped;
		}
		
		public boolean equals(Object other) {
			return other == wrapped;
		}
		
		public int hashCode() {
			return wrapped.hashCode();
		}
	}
	
	public V get(K input) {
		return map.get(new IdentityWrapper<K>(input));
	}
	
	public void put(K input, V output) {
		map.put(new IdentityWrapper<K>(input), output);
	}
}