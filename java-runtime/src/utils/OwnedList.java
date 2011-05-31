package utils;

@SuppressWarnings("serial")
public class OwnedList<T> extends java.util.ArrayList<T> {
    protected Object owner = null;
    protected boolean beingSet = false;
    protected boolean doEvents = true;

    public OwnedList() {
      super();
    }

    public OwnedList(int anticipatedSize) {
      super(anticipatedSize);
    }

    public OwnedList(java.util.List<T> list) {
      super(list);
    }

    public OwnedList(Object owner) {
      super();
      this.owner = owner;
    }

    public OwnedList(Object owner, int anticipatedSize) {
      super(anticipatedSize);
      this.owner = owner;
    }

    public OwnedList(Object owner, java.util.List<T> list) {
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
}
