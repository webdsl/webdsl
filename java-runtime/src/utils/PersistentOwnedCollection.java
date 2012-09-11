package utils;

import java.util.Map;

public interface PersistentOwnedCollection extends org.hibernate.collection.PersistentCollection {
/*	boolean isAffectedBy(String filter);
	boolean isFilterCompatible(org.hibernate.impl.FilterImpl oldFilter, org.hibernate.impl.FilterImpl newFilter);
    boolean oldFilterContains(final String oldName, final Map oldParams, final String fltrName, final Map fltrParams, final int fltrStart, final int len);*/
    org.hibernate.impl.FilterImpl getFilter();
    void setFilter(org.hibernate.impl.FilterImpl filter);
    org.hibernate.impl.FilterImpl getFilterHint();
    void setFilterHint(org.hibernate.impl.FilterImpl filterHint);
}
