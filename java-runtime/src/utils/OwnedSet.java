package utils;

@SuppressWarnings("serial")
public class OwnedSet<T> extends java.util.LinkedHashSet<T> {
    protected Object owner = null;
    protected boolean beingSet = false;
    protected boolean doEvents = true;
    protected org.hibernate.impl.FilterImpl filter = null;

    public OwnedSet() {
      super();
    }

    public OwnedSet(int anticipatedSize) {
      super(anticipatedSize);
    }

    public OwnedSet(java.util.List<T> list) {
      super(list);
    }

    public OwnedSet(Object owner) {
      super();
      this.owner = owner;
    }

    public OwnedSet(Object owner, int anticipatedSize) {
      super(anticipatedSize);
      this.owner = owner;
    }

    public OwnedSet(Object owner, java.util.List<T> list) {
      super(list);
      this.owner = owner;
    }

    public Object getOwner() {
      return owner;
    }

    public void setOwner(Object owner) {
      this.owner = owner;
    }

    public boolean getDoEvents() {
    	return doEvents;
    }

    public void setDoEvents(boolean doEvents) {
    	this.doEvents = doEvents;
    }

    public org.hibernate.impl.FilterImpl getFilter() {
    	return this.filter;
    }

    public void setFilter(org.hibernate.impl.FilterImpl filter) {
    	this.filter = filter;
    }
}
