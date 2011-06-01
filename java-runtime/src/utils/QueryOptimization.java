package utils;

public class QueryOptimization {
	public static org.hibernate.Criteria addQueryOptimization(org.hibernate.Criteria criteria, String joinstr, org.hibernate.criterion.Criterion criterion) {
		//System.out.println("addQueryOptimization");
		//System.out.println("joinstr: " + joinstr);
		//System.out.println("criterion: " + criterion);
		org.hibernate.Criteria ret = criteria;
		if(joinstr != null) {
			String[] joins = joinstr.split("\\|");
			//System.out.println("joins: " + joins.length);
			for(int i = 1; i < joins.length; i++) {
				//System.out.println("join: " + joins[i]);
				String[] varList = joins[i].split("\\.");
				if(varList.length < 1) continue;
				String joinProp = varList[varList.length - 1];
				String assaciation = joinProp;
				if(varList.length > 1) { 
					assaciation = "_" + joins[i].substring(0, joins[i].length() - joinProp.length() - 1).replace(".", "_") + "." + joinProp;
				}
				String alias = "_" + joins[i].replace(".", "_");
				//System.out.println("assaciation: " + assaciation + ", alias: " + alias);
				ret = ret.createAlias(assaciation, alias, org.hibernate.criterion.CriteriaSpecification.LEFT_JOIN);
			}
		}
		if(criterion != null) {
			//System.out.println("add criterion");
			ret = ret.add((org.hibernate.criterion.Criterion)criterion);
		}
		return ret;
	}
}
