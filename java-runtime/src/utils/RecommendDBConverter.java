package utils;

import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Hibernate;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.webdsl.lang.Environment;

/**
 * This class is used to translate the UID instances that Hibernate uses
 * to access unique instances of object classes to Big Int (in java terms a Long)
 * type of object representation. This translation is done without the user
 * or mahout knowing.
 * The recommendations functions are specified in RecommendEntityServlet, these
 * code files are seperately defined to make the code more manageable.
 * @author Oscar Castaneda
 * @author Siem Kok
 * @see RecommendEntityServlet
 */
public abstract class RecommendDBConverter {
	enum RecFieldType {
		USER, ITEM;
	}
	
	protected final String name;
	protected final String user;
	protected final String item;
	protected final String value;
	
    protected long lastExecutionTime;
    
    /**
     * The RecommendDBConverter constructor creates
     * the abstract class instance.
     * @param name The name of the entity
     * @param user The field that refers to the user instance inside the entity
     * @param item The field that refers to the item instance inside the entity
     * @param value The preference value field inside the entity
     */
    public RecommendDBConverter(String name, String user, String item, String value){
		this.name = name;
		this.user = user;
		this.item = item;
		this.value = value.length() == 0 ? null : value;
		this.lastExecutionTime = 0;
    }
	
	/**
	 * Return the execution time of the last called function that
	 * calls Mahout for measuring the precision of the database or
	 * returning recummendations.
	 * @return The time it took to execute in milli seconds.
	 */
	public long getExecutionTime(){
		return this.lastExecutionTime;
	}
	
	/**
	 * Get the class type of the entity that holds the relationship between
	 * the user and the item, possibly with the preference value as well.
	 * @return The Class instance of that entity type
	 * @throws ClassNotFoundException If the class is not found it will
	 * throw an exception
	 */
	private Class getEntityClassInstance() throws ClassNotFoundException {
		return Class.forName("webdsl.generated.domain." + this.name);
	}
	
	/**
	 * Get the class type of the user or item entity type.
	 * @param fldType Should it return a user or an item Class instance.
	 * @return The Class instance of that entity type
	 * @throws ClassNotFoundException If the class is not found it will
	 * throw an exception
	 */
	private Class getUserItemClassInstance(RecFieldType fldType) throws ClassNotFoundException, NoSuchFieldException {
		return getEntityClassInstance().getDeclaredField("_" + (fldType == RecFieldType.USER ? this.user : this.item)).getType();
	}
	
	/**
	 * Requirement: The database connection should have been opened before
	 * @param x The object reference to get the ID of
	 * @param fldType Is the supplied object a user or an item instance.
	 * @return The id of the user or item instance as a long value as it is translated
	 * and recorded in the Taste database / Dictionary.
	 * @throws Exception if it fails to get the ID, happens when a database error occurs
	 * or when an object that is not of the WebDSLEntity interface is given.
	 */
	protected long getIDOfObject(Object x, RecFieldType fldType) throws Exception {
		String retVal = null;
		org.webdsl.WebDSLEntity ent = (org.webdsl.WebDSLEntity)x;
		java.util.UUID u = (java.util.UUID)ent.getId();
		retVal = executeStatement("SELECT " + (fldType == RecFieldType.USER ? "user" : "item") + "_id AS lid FROM __" + this.name + "_Taste WHERE " + (fldType == RecFieldType.USER ? "user" : "item") + "_uid = '" + UUIDUserType.persistUUIDString(u) + "' LIMIT 1", "lid");
		return Long.parseLong(retVal);
	}
	
	private java.util.UUID getUUIDFromString(String dbuid){
		return new java.util.UUID(Long.parseLong(dbuid.substring(0, 16),16), Long.parseLong(dbuid.substring(16),16));
	}
	
	/**
	 * 
	 * @param id
	 * @param fldType Should it return a user or an item instance.
	 * @return The instance of the user or item class. Translated backwards from the Taste
	 * database / Dictionary.
	 * @throws Exception if it fails to get the instance, happens when a database error occurs
	 * or when the class type does not exist, etc.
	 */
	protected Object getObjectOfID(long id, RecFieldType fldType) throws Exception{
		// Get the UID value of the given integer id
		java.util.UUID uid = null;
		//String uid = null;
		Object x = null;
		
		String retVal = executeStatement("SELECT " + (fldType == RecFieldType.USER ? "user" : "item") + "_uid AS uidval FROM __" + this.name + "_Taste WHERE " + (fldType == RecFieldType.USER ? "user" : "item") + "_id = '" + id + "' LIMIT 1;", "uidval");
		uid = UUIDUserType.retrieveUUID(retVal);
		
		// If we got the UID of the instance, load it...
		if(uid != null){
			Class uiClass = getUserItemClassInstance(fldType);
			String uiName = uiClass.getSimpleName();
			
			PrintWriter out = ThreadLocalOut.peek();
			Environment env = ThreadLocalPage.get() != null ? ThreadLocalPage.get().envGlobalAndSession : null;
			
			return getCurrentHibernateSession().load(uiClass, uid);
		}
		return null;
	}
	
	/**
	 * Get the current hibernate session to access the database,
	 * create new instances or load instance from the database.
	 * @return The Session instance of Hibernate.
	 */
	protected Session getCurrentHibernateSession() throws Exception {
		try {
			SessionFactory sf = (SessionFactory)Class.forName("utils.HibernateUtilConfigured").getMethod("getSessionFactory").invoke(null);
			return sf.getCurrentSession();
		} catch(Exception e){
			System.err.println("Failed to get the current session of Hibernate!!!");
			e.printStackTrace();
			throw e;
		}
	}
	
	/**
	 * Since WebDSL uses a 32 byte UID representation for unique instances,
	 * and Mahout requires an 8 byte integer to determine recommendations.
	 * By calling this method a new dictionary table is generated to translate
	 * UID to integers. This table is called the taste table.
	 * Mahout directly operates on this Taste table, with this table this class
	 * will also be able to bring the integer ids back to objects in WebDSL.
	 * Requirement: Open the database before calling this method!
	 */
	protected void convertUIDToBigIntInDB(){
		try {
            System.out.println("Constructing UID Dictionary tables");
			// Drop the table of the old dictionary.
			executeStatement("DROP TABLE IF EXISTS __" + this.name + "_Taste_BeingBuilt");
			// Create the table to store the dictionary in.
			executeStatement("CREATE TABLE __" + this.name + "_Taste_BeingBuilt (user_id BIGINT UNSIGNED NOT NULL, item_id BIGINT UNSIGNED NOT NULL, user_uid varchar(32) NOT NULL, item_uid varchar(32) NOT NULL, preference FLOAT NOT NULL, PRIMARY KEY(user_id, item_id), INDEX(user_id), INDEX(item_id), INDEX(user_uid), INDEX(item_uid)) ENGINE=InnoDB;");//, FOREIGN KEY (user_uid) REFERENCES _" + this.name + "(" + this.name + "_" + this.user + "), FOREIGN KEY (item_uid) REFERENCES _" + this.name + "(" + this.name + "_" + this.item + ")) ENGINE=InnoDB;");
			
			// Drop the temporary table translation data for uids to bigints, User column
			executeStatement("DROP TABLE IF EXISTS __" + this.name + "_UserDictionary");
			// Create a temporary table to store the translation data for uids to bigints, User column
			executeStatement("CREATE TEMPORARY TABLE __" + this.name + "_UserDictionary (iid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, uid varchar(64) NOT NULL, PRIMARY KEY(iid), INDEX USING HASH (uid(10))) ENGINE=MEMORY;");//, FOREIGN KEY (uid) REFERENCES _" + this.name + "(" + this.name + "_" + this.user + ")
			
			// Drop the old temporary table to store the translation data for uids to bigints, Item column
			executeStatement("DROP TABLE IF EXISTS __" + this.name + "_ItemDictionary");
			// Create a temporary table to store the translation data for uids to bigints, Item column
			executeStatement("CREATE TEMPORARY TABLE __" + this.name + "_ItemDictionary (iid BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, uid varchar(64) NOT NULL, PRIMARY KEY(iid), INDEX USING HASH (uid(10))) ENGINE=MEMORY;");//, FOREIGN KEY (uid) REFERENCES _" + this.name + "(" + this.name + "_" + this.item + ")
			

			
			// Insert all the distinct user objects inside the translation table for the user column to generate unique big integer ids
			executeStatement("INSERT INTO __" + this.name + "_UserDictionary (uid) SELECT DISTINCT o." + this.name + "_" + this.user + " FROM _" + this.name + " AS o WHERE 1;");
			
			// Insert all the distinct item objects inside the translation table for the item column to generate unique big integer ids
			executeStatement("INSERT INTO __" + this.name + "_ItemDictionary (uid) SELECT DISTINCT o." + this.name + "_" + this.item + " FROM _" + this.name + " AS o WHERE 1;");
			
			try {
				executeStatement("DROP INDEX rec_ind ON _" + this.name + ";", false);
				System.out.println("Note: The index did exist, will be recreated");
			} catch (Exception e){
				System.out.println("Note: The index did not exist yet, no need to drop it");
			}
				
			// Add another index to the original table for faster lookup
			executeStatement("CREATE INDEX rec_ind ON _" + this.name + " (" + this.name + "_" + this.user + "(10), " + this.name + "_" + this.item + "(10));");
			
			// Use both translation tables to fill the dictionary for permanent storage
			executeStatement("INSERT DELAYED IGNORE INTO __" + this.name + "_Taste_BeingBuilt (user_id, item_id, user_uid, item_uid, preference) SELECT f.iid, g.iid, o." + this.name + "_" + this.user + ", o." + this.name + "_" + this.item + ", '0' FROM _" + this.name + " AS o LEFT JOIN __" + this.name + "_UserDictionary AS f ON f.uid = o." + this.name + "_" + this.user + " LEFT JOIN __" + this.name + "_ItemDictionary AS g ON g.uid = o." + this.name + "_" + this.item + " WHERE 1;");
			
			// Drop the previous dictionary table if it exists.
			executeStatement("DROP TABLE IF EXISTS __" + this.name + "_Taste");
			// Rename the newly created one to the accessible Dictionary table name.
			executeStatement("RENAME TABLE __" + this.name + "_Taste_BeingBuilt TO __" + this.name + "_Taste;");
			
			System.out.println ("Dictionary table has been generated!");
			
		} catch(SQLException ex){
			System.err.println("SQL Exception!! " + ex);
			ex.printStackTrace();
		}
	}
	
	/**
	 * Get the list of user or item instances from the Mahout recommendation list
	 * @param recommendations The list of recommendations given by the Mahout platform
	 * @param fldType Should it return a user or an item instance list.
	 * @return The list of user or item instances 
	 * @throws An exception if a database or cast exception occurs.
	 */
	protected List<?> getObjectsOfIDList(List<RecommendedItem> recommendations, RecFieldType fldType) throws Exception {
		List<Object> retList = new ArrayList<Object>();
		for (RecommendedItem recommendedItem : recommendations) {
			retList.add(getObjectOfID(recommendedItem.getItemID(), fldType));
		}
		return retList;
	}
	
	/**
	 * Simplified version of ExecuteStatement
	 * @param stmt The statement, see documentation of full version of executeStatement
	 * @throws SQLException Same here...
	 */
	private void executeStatement(String stmt) throws SQLException {
		executeStatement(stmt, null, true);
	}
	
	/**
	 * Simplified version of ExecuteStatement
	 * @param stmt The statement, see documentation of full version of executeStatement
	 * @throws SQLException Same here...
	 */
	private void executeStatement(String stmt, boolean printStackTrace) throws SQLException {
		executeStatement(stmt, null, printStackTrace);
	}
	
	/**
	 * Simplified version of ExecuteStatement
	 * @param stmt The statement, see documentation of full version of executeStatement
	 * @throws SQLException Same here...
	 */
	private String executeStatement(String stmt, String fld) throws SQLException {
		return executeStatement(stmt, fld, true);
	}
	
	/**
	 * This function executes the query on the database and handles
	 * exceptions correctly if any occur.
	 * @param stmt The SQL statement to execute
	 * @param fld The field to return if necessary and possible.
	 * @return The String of the field requested from the statement if there is one.
	 * @throws SQLException The SQL exception is thrown upwards such
	 * that the block of code that called this method can break its
	 * operations correctly if one of the statements fails.
	 * The exception is handled correctly inside this method though,
	 * no memory leaks.
	 */
	private String executeStatement(String stmt, String fld, boolean printStackTrace) throws SQLException {
		long startTime = System.currentTimeMillis();
		String retVal = null;
		SQLQuery q = null;
		boolean hasResultSet = false;
		try {
			System.out.print("Query:\"" + stmt + "\"\n\tExecuting...");
			q = getCurrentHibernateSession().createSQLQuery(stmt);
			if(fld != null && fld.length() > 0){
				if(fld.equals("ignore")){
					q.uniqueResult();
				} else {
					System.out.print("expecting value...");
					q.addScalar(fld, Hibernate.STRING);
					retVal = (String)q.uniqueResult();
					if(retVal != null) System.out.print(" value: " + retVal + "...");
				}
			} else {
				q.executeUpdate();
			}
			//System.out.println("Done in " + (System.currentTimeMillis() - startTime) + "ms");
			return retVal;
		} catch(SQLException ex){
			if(printStackTrace){
				System.err.println("!!! SQL Exception in Query:\n\t\"" + stmt + "\"\n\t" + ex);
				ex.printStackTrace();
			}
			throw ex;
		} catch(Exception ex){
			if(printStackTrace){
				System.err.println("!!! Exception in Query:\n\t\"" + stmt + "\"\n\t" + ex);
				ex.printStackTrace();
			}
			throw new SQLException("!!! Exception in Query:\n\t\"" + stmt + "\"\n\t" + ex);
		}
	}
	
	/**
	 * This function executes a query on the table where the recommendations
	 * should be located. In case the query fails the exception is handled
	 * correctly, because in that case the recommendation table does not exist.
	 * @return True in case the recommendation table exists.
	 */
	protected boolean checkAvailabilityOfRecommendations(){
		try {
			String s = executeStatement("SELECT 1 FROM __" + this.name + "_Taste WHERE 1 LIMIT 1;", "ignore", false);
			return true;
		} catch (SQLException e){
			return false;
		}
	}
}
