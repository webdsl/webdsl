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

	public static void prefetchProperties(org.hibernate.Criteria criteria, java.io.Serializable id, String[] props) {
		prefetchProperties(criteria, id, java.util.Arrays.asList(props));
	}

	public static void prefetchProperties(org.hibernate.Criteria criteria, java.io.Serializable id, Iterable<String> props) {
		for(String prop : props) {
			criteria.setFetchMode(prop, org.hibernate.FetchMode.JOIN);
		}
		criteria.add(org.hibernate.criterion.Restrictions.idEq(id));
	}

	public static java.util.List loadByUUID(org.hibernate.Session hibSession, String entity, java.io.Serializable id, String[] props) {
		return loadByUUID(hibSession, entity, id, java.util.Arrays.asList(props));
	}

	public static java.util.List loadByUUID(org.hibernate.Session hibSession, String entity, java.io.Serializable id, java.util.List<String> props) {
		org.hibernate.Criteria criteria = hibSession.createCriteria(entity);
		for(String prop : props) {
			criteria.setFetchMode(prop, org.hibernate.FetchMode.JOIN);
		}
		criteria.add(org.hibernate.criterion.Restrictions.idEq(id));
		return criteria.list();
	}

	public static java.util.List loadByNaturalId(org.hibernate.Session hibSession, String entity, String idProp, Object id, String[] props) {
		return loadByNaturalId(hibSession, entity, idProp, id, java.util.Arrays.asList(props));
	}

	public static java.util.List loadByNaturalId(org.hibernate.Session hibSession, String entity, String idProp, Object id, java.util.List<String> props) {
		org.hibernate.Criteria criteria = hibSession.createCriteria(entity);
		for(String prop : props) {
			criteria.setFetchMode(prop, org.hibernate.FetchMode.JOIN);
		}
		criteria.add(org.hibernate.criterion.Restrictions.naturalId().set(idProp, id));
		return criteria.list();
	}

    public static void prefetchCollections(org.hibernate.Session hibSession, String role, java.util.List<? extends org.webdsl.WebDSLEntity> owners, String[] joins) {
//    	System.out.println("prefetchCollections_" + role + ": " + owners.size());
    	if( hibSession instanceof org.hibernate.engine.SessionImplementor) {
//    		System.out.println("SessionImplementor");
    		org.hibernate.engine.SessionImplementor session = (org.hibernate.engine.SessionImplementor)hibSession;
    		org.hibernate.engine.SessionFactoryImplementor sessionFactory = session.getFactory();
			org.hibernate.persister.collection.CollectionPersister persister = sessionFactory.getCollectionPersister(role);
			if(persister instanceof utils.BatchCollectionPersister) {
//				System.out.println("BatchCollectionPersister");
				java.io.Serializable[] ownerIds = new java.io.Serializable[owners.size()];
				for(int i = 0; i < owners.size(); i++) {
					ownerIds[i] = owners.get(i).getId();
				}
				/*if(persister instanceof utils.OneToManyPersister) {
					System.out.println("roleOtM: " + role);
					System.out.println("elements: " + ((utils.OneToManyPersister)persister).getElementPersister().getEntityName());
				}
				if(persister instanceof utils.BasicCollectionPersister) {
					System.out.println("roleBasic: " + role);
					System.out.println("elements: " + ((utils.BasicCollectionPersister)persister).getElementPersister().getEntityName());
				}*/
				java.util.List<String> joinslist = null;
				if(joins != null) joinslist = java.util.Arrays.asList(joins);
				((utils.BatchCollectionPersister)persister).initializeBatch(ownerIds, session, joinslist);
			}
    	}
    }

	public static void prefetchEntities(org.hibernate.Session hibSession, String entityName, java.util.List<? extends org.webdsl.WebDSLEntity> objs, String[] joins) {
//		System.out.println("prefetchEntities_" + entityName + ": " + objs.size());
		if (hibSession instanceof org.hibernate.engine.SessionImplementor) {
//			System.out.println("SessionImplementor");
			org.hibernate.engine.SessionImplementor session = (org.hibernate.engine.SessionImplementor) hibSession;
			org.hibernate.engine.SessionFactoryImplementor sessionFactory = session.getFactory();
			org.hibernate.persister.entity.EntityPersister persister = sessionFactory.getEntityPersister(entityName);
			if (persister instanceof utils.SingleTableEntityPersister) {
//				System.out.println("SingleTableEntityPersister");
				java.util.Set<java.io.Serializable> ids = new java.util.HashSet<java.io.Serializable>();
				for (int i = 0; i < objs.size(); i++) {
					final Object obj = objs.get(i);
					if (obj instanceof org.hibernate.proxy.HibernateProxy) {
						org.hibernate.proxy.LazyInitializer init = ((org.hibernate.proxy.HibernateProxy) obj).getHibernateLazyInitializer();
						if (init.isUninitialized()) {
//							System.out.println("Uninitialized: " + init.getIdentifier());
//							System.out.println("isInitialized?: " + org.hibernate.Hibernate.isInitialized(obj));
							ids.add(init.getIdentifier());
						}
					}
				}
//				System.out.println("left: " + ids.size());
				if (ids.size() > 1) {
//					System.out.println("calling loadBatch");
					try {
						java.util.List<String> joinslist = null;
						if(joins != null) joinslist = java.util.Arrays.asList(joins);
						((utils.SingleTableEntityPersister) persister).loadBatch(ids.toArray(new java.io.Serializable[ids.size()]), session, joinslist);
					} catch (Exception ex) {
						ex.printStackTrace();
					}
//					System.out.println("called loadBatch");
				}
			}
		}
		for (int i = 0; i < objs.size(); i++) {
			final Object obj = objs.get(i);
			if (obj instanceof org.hibernate.proxy.HibernateProxy) {
				org.hibernate.proxy.LazyInitializer init = ((org.hibernate.proxy.HibernateProxy) obj)
						.getHibernateLazyInitializer();
				if (init.isUninitialized()) {
					init.initialize();
				}
			}
		}
//		System.out.println("exit prefetchEntities");
	}
}
