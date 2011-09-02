package utils;

import java.util.Arrays;

public class QueryOptimization {
	public static org.hibernate.Criteria addQueryOptimization(org.hibernate.Criteria criteria, String[] curjoins, String curgen, boolean ismain, String[] joins, String[][] queries, org.hibernate.criterion.Criterion criterion, String[] condjoins) {
		org.hibernate.Criteria ret = criteria;
		java.util.ArrayList<String> tojoin = new java.util.ArrayList<String>(); 

		// Add joins needed for the conditions first
		if(condjoins != null && condjoins.length > 0) {
			tojoin.addAll(Arrays.asList(condjoins));
		}

		// If this is the first queries we need to add all non-generic joins
		if(ismain && joins != null && joins.length > 0) {
			tojoin.addAll(Arrays.asList(joins));
		}

		// Add joins starting with the generic property curgen
		if(curgen != null && queries != null) {
			for(int i = 0; i < queries.length; i++) {
				if(queries[i].length > 0 && curgen.equals(queries[i][0])) {
					tojoin.addAll(Arrays.asList(queries[i]));
					break;
				}
			}
		}

		if(curjoins != null && tojoin.size() > 0) {
			tojoin.removeAll(Arrays.asList(curjoins)); // Remove all joins that are already added to the criteria
		}

		if(tojoin.size() > 0) {
			ret = QueryOptimization.addJoins(ret, tojoin).setCacheable(false); // Add the selected joins to the criteria
			// We added joins, which are not executed if the query is cached, so that is why we disable caching here
		}

		if(criterion != null) { // Add the condition aswell
			ret = ret.add((org.hibernate.criterion.Criterion)criterion);
		}
		return ret;
	}

	public static org.hibernate.Criteria addJoins(org.hibernate.Criteria criteria, java.util.ArrayList<String> joins) {
		org.hibernate.Criteria ret = criteria;
		for(int i = 0; i < joins.size(); i++) {
			String join = joins.get(i);
			String[] varList = join.split("\\.");
			if(varList.length < 1) continue;
			String joinProp = varList[varList.length - 1];
			String assaciation = joinProp;
			if(varList.length > 1) {
				assaciation = "_" + join.substring(0, join.length() - joinProp.length() - 1).replace(".", "_") + "." + joinProp;
			}
			String alias = "_" + join.replace(".", "_");
			ret = ret.createAlias(assaciation, alias, org.hibernate.criterion.CriteriaSpecification.LEFT_JOIN);
		}
		return ret;
	}

	public static org.hibernate.criterion.Criterion getNotEqCondition(String prop, Object val) {
		if(val == null) {
			return org.hibernate.criterion.Restrictions.isNotNull(prop);
		}
		return org.hibernate.criterion.Restrictions.ne(prop, val);
	}

	public static org.hibernate.criterion.Criterion getEqCondition(String prop, Object val, boolean naturalId) {
		if(val == null) {
			return org.hibernate.criterion.Restrictions.isNull(prop);
		}
		if(naturalId) {
			return org.hibernate.criterion.Restrictions.naturalId().set(prop, val);
		}
		return org.hibernate.criterion.Restrictions.eq(prop, val);
	}
}
