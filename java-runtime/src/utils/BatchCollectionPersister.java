package utils;

import java.io.Serializable;
import org.hibernate.engine.SessionImplementor;

public interface BatchCollectionPersister {

	public void initializeBatch(Serializable[] batch, SessionImplementor session, java.util.List<String> joins);

}
