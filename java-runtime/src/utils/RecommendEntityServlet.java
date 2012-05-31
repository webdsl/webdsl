package utils;

import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.apache.mahout.cf.taste.common.NoSuchUserException;
import org.apache.mahout.cf.taste.common.Refreshable;
import org.apache.mahout.cf.taste.common.TasteException;
import org.apache.mahout.cf.taste.eval.DataModelBuilder;
import org.apache.mahout.cf.taste.eval.IRStatistics;
import org.apache.mahout.cf.taste.eval.RecommenderBuilder;
import org.apache.mahout.cf.taste.impl.common.FastByIDMap;
import org.apache.mahout.cf.taste.impl.eval.GenericRecommenderIRStatsEvaluator;
import org.apache.mahout.cf.taste.impl.model.GenericBooleanPrefDataModel;
import org.apache.mahout.cf.taste.impl.model.jdbc.MySQLJDBCDataModel;
import org.apache.mahout.cf.taste.impl.neighborhood.NearestNUserNeighborhood;
import org.apache.mahout.cf.taste.impl.neighborhood.ThresholdUserNeighborhood;
import org.apache.mahout.cf.taste.impl.recommender.CachingRecommender;
import org.apache.mahout.cf.taste.impl.recommender.GenericBooleanPrefUserBasedRecommender;
import org.apache.mahout.cf.taste.impl.recommender.GenericItemBasedRecommender;
import org.apache.mahout.cf.taste.impl.recommender.GenericUserBasedRecommender;
import org.apache.mahout.cf.taste.impl.similarity.EuclideanDistanceSimilarity;
import org.apache.mahout.cf.taste.impl.similarity.LogLikelihoodSimilarity;
import org.apache.mahout.cf.taste.impl.similarity.PearsonCorrelationSimilarity;
import org.apache.mahout.cf.taste.impl.similarity.TanimotoCoefficientSimilarity;
import org.apache.mahout.cf.taste.model.DataModel;
import org.apache.mahout.cf.taste.model.PreferenceArray;
import org.apache.mahout.cf.taste.neighborhood.UserNeighborhood;
import org.apache.mahout.cf.taste.recommender.RecommendedItem;
import org.apache.mahout.cf.taste.recommender.Recommender;
import org.apache.mahout.cf.taste.similarity.ItemSimilarity;
import org.apache.mahout.cf.taste.similarity.UserSimilarity;

/**
 * This class interfaces to the WebDSL code using the Recommend syntax.
 * By specifying a recommend configuration block for a certain entity
 * relation the Recommend engine will generate all the code necessary
 * to talk to Mahout, build translation tables and other magic tricks
 * to make it work.
 * To set-up recommendations for a certain relation between two entity
 * types you need to distinguish the type of the entities first. The two
 * types that exist are user and item types in Mahout terms. The user
 * type is the object that prefers things, while the item type are the
 * things that are prefered. So in an example with a bookstore the item
 * is the book, while the user is the customer who bought the book.
 * To configure this relation we assume you have something similar to this
 * example:
 * <code>
 * entity User {
 * 	name :: String(id)
 *  books :: List<BoughtBook>
 * }
 *
 * entity BoughtBook {
 * 	by -> User
 *  book -> Book
 *  rating :: Int
 * }
 *
 * entity Book {
 * 	name :: String(id)
 *  author :: String
 * }
 *
 * recommend BoughtBook {
 * 	user=by
 * 	item=book
 * 	value=rating
 * }
 * </code>
 * @author Oscar Castaneda
 * @author Siem Kok
 * @see RecommendDBConverter
 */
public class RecommendEntityServlet extends RecommendDBConverter implements DataSource {

	private static final String A_EUCLIDEAN 	= "euclidean";
	private static final String A_PEARSON 		= "pearson";
	private static final String A_LOGLIKELIHOOD = "loglikelihood";
	private static final String A_TANIMOTO 		= "tanimoto";
	private static final String N_NUSER			= "nuser";
	private static final String N_THRESHOLD		= "threshold";
	private static final String T_USER			= "user";
	private static final String T_ITEM			= "item";
	private static final String T_BOTH			= "both";
	private final String alg;
	private final String neighborhoodAlg;
	private final double neighborhoodSize;
	private final String type;
    private Recommender userRecommenderCache;
    private Recommender itemRecommenderCache;
    private int timeout;
    private PrintWriter pw;
    private Method connectionMethod;

    /**
     * Generate a new instance of the recommend entity servlet, this stores the
     * field names and entity name in the objects private variables.
     * @param name The name of the entity
     * @param user The field that refers to the user instance inside the entity
     * @param item The field that refers to the item instance inside the entity
     * @param value The preference value field inside the entity
     * @param alg The algorithm that should be used for producing recommendations
     * @param nalg The neighborhood algorithm that should be used to find recommendations
     * @param nsize The size of the neigborhood to look in
     * @param type The type of the recommendations that will be required, either user, item or both.
     */
	public RecommendEntityServlet(String name, String user, String item, String value, String alg, String nalg, int nsize, String type){
		super(name, user, item, value);
		this.alg = alg.length() == 0 ? null : alg;
		this.neighborhoodAlg = nalg.length() == 0 ? null : nalg;
		this.neighborhoodSize = nsize == 0 ? 9 : nsize;
		this.type = type.length() == 0 ? null : type;
		this.userRecommenderCache = null;
		this.itemRecommenderCache = null;
        this.timeout = 30;
        this.pw = new PrintWriter(System.out, true);
	}

	/**
	 * Builds a new Mahout Database model that connects to the MySQL
	 * database using the credentials set-up in the WebDSL configuration.
	 * @return The Mahoud JDBC Data Model instance
	 */
	private MySQLJDBCDataModel getMahoutDatabaseModel(){
        /*
         * Give Mahout this instance as the data source, Mahout will be able
         * to call the getConnection method to obtain the database jdbc connection
         * with the database that Hibernate is connected to. This has been implemented
         * like this so the H2 database could also be integrated. However, the function
         * used to obtain the datasource (Session.connection() of Hibernate is set to
         * deprecate in version 4. However, from what I read in their internal docs
         * they are still not convinced to remove it completely, because a lot of
         * customers need this function for their products.
         * Look at rev: 4809 for the version that used the properties of Hibernat
         * to set-up the database connection if you need to replace this later on.
         * ~ Siem
         */
        return new MySQLJDBCDataModel(this, "__"+this.name+"_Taste", "user_id", "item_id", "preference", null);
	}

    /**
     * The getConnection function makes sure that Mahout is able to access the
     * same data source as Hibernate, without requiring the configuration to be read.
     * @return The Connection instance for Mahout to connect to.
     */
    public Connection getConnection() {
    	try {
            if (connectionMethod == null) {
                // reflective lookup to bridge between Hibernate 3.x and 4.x
                connectionMethod = getCurrentHibernateSession().getClass().getMethod("connection");
            }
            return (Connection) connectionMethod.invoke(getCurrentHibernateSession());
        }
        catch (NoSuchMethodException ex) {
            throw new IllegalStateException("Cannot find connection() method on Hibernate session", ex);
        } catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return null;
    }

    /**
     * The getConnection function makes sure that Mahout is able to access the
     * same data source as Hibernate, without requiring the configuration to be read.
     * @param username The username to connect to the database, is not used.
     * @param password The password to connect to the database, is not used.
     * @return The Connection instance for Mahout to connect to.
     */
    public Connection getConnection(String username, String password) {
        return getConnection();
    }

    /**
     * Get the login time-out configuration that is set at this moment.
     * @return The login time-out in seconds (default is 30).
     */
    public int getLoginTimeout(){
        return this.timeout;
    }

    /**
     * Get the log writer that is set for the connection to write its
     * log output to.
     * @return The PrintWriter instance.
     */
    public PrintWriter getLogWriter(){
        return this.pw;
    }

    /**
     * Set the login time-out value, default is 30 seconds.
     * @param seconds The time-out value to set it to.
     */
    public void setLoginTimeout(int seconds){
        this.timeout = seconds;
    }

    /**
     * Set the log writer for the connection to output its
     * log records to.
     * @param out The new PrintWriter instance to use.
     */
    public void setLogWriter(PrintWriter out){
        this.pw = out;
    }

    /**
     * For the DataSource implementation it is required that
     * you can refer to this function, the implementation forwards
     * the wrapper request to the connection.
     * @param iface The iface to check if we can wrap it or not
     * @return true if we are a wrapper for this class.
     */
    public boolean isWrapperFor(Class<?> iface) throws java.sql.SQLException {
        return this.getConnection().isWrapperFor(iface);
    }

    /**
     * Unwrap the given class instance accordingly
     * @param iface The iface to unwrap
     * @return The unwrapped instance of this class.
     */
    public <T> T unwrap(Class<T> iface) throws java.sql.SQLException {
        return this.getConnection().unwrap(iface);
    }

	/**
	 * Give the recommendations based on the supplied User instance.
	 * This will make the calls to Mahout and ask it to give recommendations
	 * for the given User instance that this user is likely interested in.
	 * Although we speak about Users here, this can be any object type.
	 * Note: The recommendations that are returned are the result of the
	 * algorithm you use, if the results do not match your expectations, please
	 * try using another algorithm. See the documentation for more information.
	 * @param x The user object to give recommendations of.
	 * @param howMany The number of recommendations you would like to get.
	 * @param aType The type of the recommendation, either USER (in case of User
	 * to Item recommendations) or ITEM (in case of Item to Item recommendations)
	 * @return A list with recommended items that are recommended by Mahout
	 * for this user.
	 */
	public List<?> getRecommendations(Object x, int howMany, RecFieldType aType) {
		if(checkAvailabilityOfRecommendations(aType) == false){
			System.err.println("Warning, you request to get recommendations while the recommendations taste table has not yet been filled by Mahout.\nEither wait for it to finish its background task, or call the reconstructRecommendCache function (last option should be used with care, on non-production systems only.)");
			return new ArrayList<Object>();
		}
		long startTime = System.currentTimeMillis();

		try {
			long id = getIDOfObject(x, aType);

			List<RecommendedItem> recommendations = aType == RecFieldType.USER ? this.userRecommenderCache.recommend(id, howMany) : this.itemRecommenderCache.recommend(id, howMany);

			this.lastExecutionTime = System.currentTimeMillis() - startTime;
			//System.out.println("Obtaining the list of recommendations took: " + this.lastExecutionTime);
			return getObjectsOfIDList(recommendations, RecFieldType.ITEM);
        } catch(NoSuchUserException nse){
            /* Recommendations cannot be given because the user is unknown */
			return new ArrayList<Object>();
		} catch (Exception e){
			System.err.println("Error, catched an exception while obtaining the recommendations! " + e);
			e.printStackTrace();
			return new ArrayList<Object>();
		}
	}

	/**
	 * This function will (re)construct all the recommendations using
	 * Mahout.
	 * NOTE: Be aware that this is a very expensive function in terms of
	 * processing time, therefore this function is called on a regular
	 * interval (say every x hours) to update the recommendation cache
	 * according to the latest data available in the database.
	 */
	public void reconstructRecommendationCache(){
		long startTime = System.currentTimeMillis();

		try {
			/* Open the database and update the dictionary to Mahout style */
			convertUIDToBigIntInDB();

			/*
			 * Database is converted, generate the recommendations seperately
			 * from the currently cached recommendations if there are any.
			 */
			MySQLJDBCDataModel model = getMahoutDatabaseModel();

			/*
			 * Build the recommender itself.
			 */
			Recommender userRecommender = null;
			Recommender itemRecommender = null;
			if(this.type == null || this.type.equalsIgnoreCase(T_USER) || this.type.equalsIgnoreCase(T_BOTH)){
				userRecommender = buildRecommenderInstance(model, RecFieldType.USER);
			}
			if(this.type == null || this.type.equalsIgnoreCase(T_ITEM) || this.type.equalsIgnoreCase(T_BOTH)){
				itemRecommender = buildRecommenderInstance(model, RecFieldType.ITEM);
			}

			/*
			 * The recommendation process has finished, replace the cached
			 * recommendations with the new updated version.
			 */
			if(this.type == null || this.type.equalsIgnoreCase(T_USER) || this.type.equalsIgnoreCase(T_BOTH)){
				this.userRecommenderCache = new CachingRecommender(userRecommender);
			}
			if(this.type == null || this.type.equalsIgnoreCase(T_ITEM) || this.type.equalsIgnoreCase(T_BOTH)){
				this.itemRecommenderCache = new CachingRecommender(itemRecommender);
			}
			this.lastExecutionTime = System.currentTimeMillis() - startTime;
			System.out.println("Building the Mahout Index took: " + this.lastExecutionTime);
		} catch (Exception e){
			System.err.println("\n\n************ SEVERE ERROR ************\nThere was an exception while reconstructing the recommendations!\n" + e);
			e.printStackTrace();
			System.err.println("************ END OF ERROR ************\n\n");
		}
	}

	/**
	 * Get the similarity instance that is used to check which users and items
	 * are similar. There are several implementations for this, these are specified
	 * by the this.alg value of the RecommendEntityServlet instance.
	 * NOTE: Since there are two interfaces: ItemSimilarity and UserSimilarity the
	 * returned type is of the interface Refreshable since both interfaces inherit
	 * that type as well. Cast it to the right type.
	 * @param model The database model to use for the similarity calculations
	 * @return The UserSimilarity or ItemSimilarity instance.
	 * @throws TasteException If an exception is thrown by Mahout it is forwarded upwards.
	 */
	private Refreshable getSimularity(DataModel model) throws TasteException {
		if(this.alg.equalsIgnoreCase(A_EUCLIDEAN)){
			return new EuclideanDistanceSimilarity(model);
		} else if(this.alg.equalsIgnoreCase(A_PEARSON)){
			return new PearsonCorrelationSimilarity(model);
		} else if(this.alg.equalsIgnoreCase(A_TANIMOTO)){
			return new TanimotoCoefficientSimilarity(model);
		} else if(this.alg.equalsIgnoreCase(A_LOGLIKELIHOOD) || this.alg == null){ // == null is the default case
			return new LogLikelihoodSimilarity(model);
		} else {
			throw new TasteException("Unknown algorithm type: " + this.alg);
		}
	}

	/**
	 * Get the user neighborhood instance, with the correct neighborhood size and algorithm
	 * as specified during the construction of this RecommendEntityServlet.
	 * @param similarity The similarity to form the neighborhood
	 * @param model The database model to get the neighborhood of
	 * @return The UserNeighborhood instance
	 * @throws Exception If an exception is thrown by Mahout it is forwarded upwards.
	 */
	private UserNeighborhood getNeighborhood(UserSimilarity similarity, DataModel model) throws TasteException {
		if(this.neighborhoodAlg.equalsIgnoreCase(N_THRESHOLD)){
			return new ThresholdUserNeighborhood(this.neighborhoodSize, similarity, model);
		} else if(this.neighborhoodAlg.equalsIgnoreCase(N_NUSER) || this.neighborhoodAlg == null){ // == null is the default case
			return new NearestNUserNeighborhood((int)this.neighborhoodSize, similarity, model);
		} else {
			throw new TasteException("Unknown neighborhood algorithm type: " + this.neighborhoodAlg);
		}
	}

	/**
	 * Build the recommender instance based on the configuration
	 * that is specified for this RecommendEntityServlet instance.
	 * @param model The model instance to recommend on, a.k.a. the database model
	 * @param aType The type of the recommendation, either USER or ITEM
	 * @return The recommender instance with the correct similarity and neighborhood settings
	 * @throws TasteException If an exception is thrown by Mahout it is forwarded upwards.
	 */
	private Recommender buildRecommenderInstance(DataModel model, RecFieldType aType) throws TasteException {
		if(aType == RecFieldType.USER){
			UserSimilarity similarity = (UserSimilarity)getSimularity(model);

			UserNeighborhood neighborhood = getNeighborhood(similarity, model);

			if(this.value == null){ // == null, so there is no value set.
				return new GenericBooleanPrefUserBasedRecommender(model, neighborhood, similarity);
			} else {
				return new GenericUserBasedRecommender(model, neighborhood, similarity);
			}
		} else { //type == RecFieldType.ITEM
			ItemSimilarity similarity = (ItemSimilarity)getSimularity(model);

			return new GenericItemBasedRecommender(model, similarity);
		}
	}

	/**
	 * The performance of Mahout operating on the database depends on
	 * the algorithm that is chosen by the developer of the WebDSL project.
	 * Each algorithm performs differently according to the boolean or preference
	 * relation type, the number of records, and other factors that are further
	 * discussed in the documentation.
	 * This function allows the developer to test the performance of the chosen
	 * algorithm and database set to see if the result matches his expectations.
	 * NOTE: The performance of this query can be determined by calling the
	 * getExecutionTime() function on this instance.
	 * @return The float value of the precision and the recall float value, both
	 * encapsulated in a string, for example: "0.2714285714285714 :: 0.2857142852714785"
	 */
	public String evaluateIRStats() {
		// Since we are not interested in the time that it takes to generate the
		// translation tables, this function call is outside the scope of the performance
		// calculations.
		//return "Hooray";

		// Only rebuild the recommendation cache if it is absolutely necessary.
		// Hopefully this will already be done using the background periodical
		// calls to the function. But in case the developer just launched this
		// application we need to contruct it first, will take a long, long, long time.
		if(this.userRecommenderCache == null && this.itemRecommenderCache == null) reconstructRecommendationCache();

		MySQLJDBCDataModel model = getMahoutDatabaseModel();

		long startTime = System.currentTimeMillis();

		try {
			GenericRecommenderIRStatsEvaluator evaluator = new GenericRecommenderIRStatsEvaluator();
			RecommenderBuilder recommenderBuilder = null;
			if(this.type != null && this.type.equalsIgnoreCase(T_ITEM)){
				recommenderBuilder = new RecommenderBuilder() {
					public Recommender buildRecommender(DataModel model) throws TasteException {
						return buildRecommenderInstance(model, RecFieldType.ITEM);
					}
				};
			} else { // this.type == null || this.type.equalsIgnoreCase(T_BOTH) || this.type.equalsIgnoreCase(T_USER)
				recommenderBuilder = new RecommenderBuilder() {
					public Recommender buildRecommender(DataModel model) throws TasteException {
						return buildRecommenderInstance(model, RecFieldType.USER);
					}
				};
			}

			DataModelBuilder modelBuilder = new DataModelBuilder() {
				//Override
				public DataModel buildDataModel(FastByIDMap<PreferenceArray> trainingData) {
					return new GenericBooleanPrefDataModel(GenericBooleanPrefDataModel.toDataMap(trainingData));
				}
			};

			IRStatistics stats = evaluator.evaluate(
					recommenderBuilder, modelBuilder, model, null, 10, GenericRecommenderIRStatsEvaluator.CHOOSE_THRESHOLD, 1.0);

			this.lastExecutionTime = System.currentTimeMillis() - startTime;
			return stats.getPrecision() + " :: " + stats.getRecall();
		} catch(java.lang.IllegalArgumentException e){
			// This error happens when the data set available in the database is not large
			// enough to calculate the precision and recall values.
			return "Failed, the given data set is not large enough to calculate precision and recall. Please provide more samples to proceed.";
		} catch (TasteException e) {
			e.printStackTrace();
		}  catch (Exception e) {
			e.printStackTrace();
		}

		this.lastExecutionTime = System.currentTimeMillis() - startTime;
		return "FAILED";

	}

	/**
	 * This function executes a query on the table where the recommendations
	 * should be located. In case the query fails the exception is handled
	 * correctly, because in that case the recommendation table does not exist.
	 * @param aType The type of the recommendations that should be checked
	 * @return True in case the recommendation table exists.
	 */
	protected boolean checkAvailabilityOfRecommendations(RecFieldType aType){
		if(aType == RecFieldType.USER && this.type.equalsIgnoreCase(T_ITEM)){
			System.err.println("\n\n************************************************************\nSEVERE ERROR:\tYou have specified to use only the item-to-item recommendations, while you ask it for user recommendations now!\n************************************************************\n\n");
			return false;
		}
		if(aType == RecFieldType.ITEM && this.type.equalsIgnoreCase(T_USER)){
			System.err.println("\n\n************************************************************\nSEVERE ERROR:\tYou have specified to use only the user-to-item recommendations, while you ask it for item recommendations now!\n************************************************************\n\n");
			return false;
		}
		if((aType == RecFieldType.USER && this.userRecommenderCache == null) || (aType == RecFieldType.ITEM && this.itemRecommenderCache == null)) return false;
		return super.checkAvailabilityOfRecommendations();
	}
}
