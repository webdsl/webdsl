package org.webdsl.search;

import java.util.ArrayList;
import java.util.Map;

import org.hibernate.search.stat.Statistics;

import utils.ThreadLocalPage;

public class SearchStatistics {

	private static Statistics stats;
	
	static{
		try{
			stats = org.hibernate.search.Search.getFullTextSession(ThreadLocalPage.get().getHibSession()).getSearchFactory().getStatistics();
		} catch (Exception ex) {
			System.out.println("!!!!!!!!  Search factory failed to load, unable to get statistics !!!!!!!");
			ex.printStackTrace();
			//ignore exception, because it is probably thrown when running reindex script (using new java vm instance). Hibernate session and thus search factory cannot be retrieved then.  
			stats = null;
		}
	}
	
    /**
     * Reset all statistics.
     */
     public static void clear(){
		stats.clear();
	 }

    /**
     * Get global number of executed search queries
     *
     * @return search query execution count
     */
     public static long getSearchQueryExecutionCount(){
		return stats.getSearchQueryExecutionCount();
	}

    /**
     * Get the total search time in nanoseconds.
     */
     public static long getSearchQueryTotalTime(){
		return stats.getSearchQueryTotalTime();
	}

    /**
     * Get the time in nanoseconds of the slowest search.
     */
     public static long getSearchQueryExecutionMaxTime(){
		return stats.getSearchQueryExecutionMaxTime();
	}

    /**
     * Get the average search time in nanoseconds.
     */
     public static long getSearchQueryExecutionAvgTime(){
		return stats.getSearchQueryExecutionAvgTime();
	}

    /**
     * Get the query string for the slowest query.
     */
     public static String getSearchQueryExecutionMaxTimeQueryString(){
		return stats.getSearchQueryExecutionMaxTimeQueryString();
	}

    /**
     * Get the total object loading in nanoseconds.
     */
     public static long getObjectLoadingTotalTime(){
		return stats.getObjectLoadingTotalTime();
	}

    /**
     * Get the time in nanoseconds for the slowest object load.
     */
     public static long getObjectLoadingExecutionMaxTime(){
		return stats.getObjectLoadingExecutionMaxTime();
	}

    /**
     * Get the average object loading time in nanoseconds.
     */
     public static long getObjectLoadingExecutionAvgTime(){
		return stats.getObjectLoadingExecutionAvgTime();
	}

    /**
     * Gets the total number of objects loaded
     */
     public static long getObjectsLoadedCount(){
		return stats.getObjectsLoadedCount();
	}

    /**
     * Are statistics logged
     */
     public static boolean isStatisticsEnabled(){
		return stats.isStatisticsEnabled();
	}

    /**
     * Enable statistics logs (this is a dynamic parameter)
     */
     public static void setStatisticsEnabled(boolean b){
		
	}

    /**
     * Returns the Hibernate Search version.
     *
     * @return the Hibernate Search version
     */
     public static String getSearchVersion(){
		return stats.getSearchVersion();
	}

    /**
     * Returns a list of all indexed classes.
     *
     * @return list of all indexed classes
     */
     public static ArrayList<String> getIndexedClassNames(){
		return new ArrayList<String>(stats.getIndexedClassNames());
	}

//    /**
//     * Returns the number of documents for the given entity.
//     *
//     * @param entity the fqc of the entity
//     *
//     * @return number of documents for the specified entity name
//     *
//     * @throws IllegalArgumentException in case the entity name is not valid
//     */
//     public static int getNumberOfIndexedEntities(String entity){
//		
//	}

    /**
     * Returns a map of all indexed entities and their document count in the index.
     *
     * @return a map of all indexed entities and their document count. The map key is the fqc of the entity and
     *         the map value is the document count.
     */
     public static ArrayList<String> indexedEntitiesCount(){
		Map<String, Integer> map = stats.indexedEntitiesCount();
		ArrayList<String> list = new ArrayList<String>();
		
		for (java.util.Map.Entry<String, Integer> element : map.entrySet()) {
			list.add(element.getKey() + " - " + element.getValue());
		}
		return list;
	}
	
	
	
}
