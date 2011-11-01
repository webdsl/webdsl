package utils;

import java.io.Serializable;

import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.LockMode;
import org.hibernate.LockOptions;
import org.hibernate.MappingException;
import org.hibernate.cache.access.EntityRegionAccessStrategy;
import org.hibernate.engine.LoadQueryInfluencers;
import org.hibernate.engine.Mapping;
import org.hibernate.engine.SessionFactoryImplementor;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.loader.entity.EntityLoader;
import org.hibernate.mapping.PersistentClass;

public class SingleTableEntityPersister extends org.hibernate.persister.entity.SingleTableEntityPersister {

	//protected BatchingEntityLoader batchLoader = null;

	public SingleTableEntityPersister(PersistentClass persistentClass,
			EntityRegionAccessStrategy cacheAccessStrategy,
			SessionFactoryImplementor factory,
			Mapping mapping) throws HibernateException {
		super(persistentClass, cacheAccessStrategy, factory, mapping);
	}
/*
	@Override
	protected void createLoaders() {
		super.createLoaders();
		batchLoader = BatchingEntityLoader.createBatchingEntityLoader(this, getFactory());
	}

	@Override
	public Object load(Serializable id, Object optionalObject, org.hibernate.LockOptions lockOptions, SessionImplementor session)
	throws HibernateException {

	return super.load(id, optionalObject, lockOptions, session);
	}
*/
	public void loadBatch(Serializable[] batch, SessionImplementor session, java.util.List<String> joins) {
		if(batch.length == 0) return;
		if(java.lang.reflect.Proxy.isProxyClass( session.getClass() ) ) {
			if(session instanceof org.hibernate.Session) {
				Object realSession = ((org.hibernate.Session)session).getSession(session.getEntityMode());
				if(realSession instanceof SessionImplementor) {
					session = (SessionImplementor)realSession;
				}
				else {
					return;
				}
			}
			else {
				return;
			}
		}

		JoinEntityLoader loader = new JoinEntityLoader(this, batch.length, LockMode.NONE, session.getFactory(), session.getLoadQueryInfluencers(), joins);
		loader.loadEntityBatch(session, batch, getIdentifierType(), null, getEntityName(), null, this, LockOptions.NONE);
		//batchLoader.loadBatch(batch, session);
		/*org.hibernate.Criteria criteria = ((org.hibernate.Session)session).createCriteria(this.getEntityName());
		if(joins != null) {
			for(String str : joins) {
				criteria.setFetchMode(str, FetchMode.JOIN);
			}
		}
		criteria.add(org.hibernate.criterion.Restrictions.in("id", batch));
		criteria.list();*/
	}

	public void loadLazyBatch(String propertyName, Serializable[] batch, SessionImplementor session, java.util.List<String> joins) {
		if(batch.length == 0) return;

		if(java.lang.reflect.Proxy.isProxyClass( session.getClass() ) ) {
			if(session instanceof org.hibernate.Session) {
				Object realSession = ((org.hibernate.Session)session).getSession(session.getEntityMode());
				if(realSession instanceof SessionImplementor) {
					session = (SessionImplementor)realSession;
				}
				else {
					return;
				}
			}
			else {
				return;
			}
		}

        org.hibernate.EntityMode entityMode = session.getEntityMode();
        org.hibernate.engine.SessionFactoryImplementor factory = session.getFactory();
        org.hibernate.engine.PersistenceContext context = session.getPersistenceContext();
		org.hibernate.type.EntityType type = (org.hibernate.type.EntityType) getPropertyType(propertyName);
		String associatedEntity = type.getAssociatedEntityName();
		String uniqueKeyPropertyName = type.getRHSUniqueKeyPropertyName();
		utils.SingleTableEntityPersister associatedPersister = (utils.SingleTableEntityPersister)factory.getEntityPersister(associatedEntity);
		String[] columns = associatedPersister.getPropertyColumnNames(uniqueKeyPropertyName);
        org.hibernate.type.Type ukType = associatedPersister.getPropertyType(uniqueKeyPropertyName);
        JoinEntityLoader loader = new JoinEntityLoader(associatedPersister, columns, ukType, batch.length, LockMode.NONE, factory, session.getLoadQueryInfluencers(), joins);
		java.util.List lst = loader.loadEntityBatch(session, batch, getIdentifierType(), null, associatedEntity, null, associatedPersister, LockOptions.NONE);
		// We register the EntityUniqueKeys with the persistence context, so the we can look them up later
		for(Object object : lst) {
			org.hibernate.engine.EntityUniqueKey euk = new org.hibernate.engine.EntityUniqueKey(
					associatedEntity, 
					uniqueKeyPropertyName, 
					getIdentifier(associatedPersister.getPropertyValue(object, uniqueKeyPropertyName, entityMode), session), // Returns the identifier that was used to fetch the object (from batch)
					ukType,
					entityMode, 
					factory
			);
			context.addEntity( euk, object );
		}
	}

	class JoinEntityLoader extends org.hibernate.loader.entity.AbstractEntityLoader {

		private final boolean batchLoader;
		private final int[][] compositeKeyManyToOneTargetIndices;
		private final LockOptions lockOptions = new LockOptions();

		JoinEntityLoader(
				org.hibernate.persister.entity.OuterJoinLoadable persister,
				int batchSize,
				LockMode lockMode,
				SessionFactoryImplementor factory,
				LoadQueryInfluencers loadQueryInfluencers, java.util.List<String> joins) throws MappingException {
			this(
					persister,
					persister.getIdentifierColumnNames(),
					persister.getIdentifierType(),
					batchSize,
					lockMode,
					factory,
					loadQueryInfluencers,
					joins
				);
		}
		public JoinEntityLoader(
				org.hibernate.persister.entity.OuterJoinLoadable persister,
				String[] uniqueKey,
				org.hibernate.type.Type uniqueKeyType, 
				int batchSize, 
				LockMode lockMode,
				SessionFactoryImplementor factory, 
				LoadQueryInfluencers loadQueryInfluencers, java.util.List<String> joins) throws MappingException {
			super( persister, uniqueKeyType, factory, loadQueryInfluencers );
			this.lockOptions.setLockMode(lockMode);
			final java.util.List<String> joinpaths = joins;
			org.hibernate.loader.entity.EntityJoinWalker walker = new org.hibernate.loader.entity.EntityJoinWalker(
					persister, 
					uniqueKey, 
					batchSize, 
					lockMode, 
					factory, 
					loadQueryInfluencers
			){
				protected int getJoinType(
						org.hibernate.persister.entity.OuterJoinLoadable persister,
						org.hibernate.loader.PropertyPath path,
						int propertyNumber,
						org.hibernate.type.AssociationType associationType,
						org.hibernate.FetchMode metadataFetchMode,
						org.hibernate.engine.CascadeStyle metadataCascadeStyle,
						String lhsTable,
						String[] lhsColumns,
						boolean nullable,
						int currentDepth) throws MappingException {
					if ( lockOptions.getLockMode().greaterThan( LockMode.READ ) ) {
						return -1;
					}
					if ( isTooDeep( currentDepth )
							|| ( associationType.isCollectionType() && isTooManyCollections() ) ) {
						return -1;
					}
					if ( !isJoinedFetchEnabledInMapping( metadataFetchMode, associationType )
							&& !isJoinFetchEnabledByProfile( persister, path, propertyNumber )
							&& (joinpaths == null || !joinpaths.contains(path.getFullPath()))) {
						return -1;
					}
					if ( isDuplicateAssociation( lhsTable, lhsColumns, associationType ) ) {
						return -1;
					}
					return getJoinType( nullable, currentDepth );
				}
			};
			initFromWalker( walker );
			this.compositeKeyManyToOneTargetIndices = walker.getCompositeKeyManyToOneTargetIndices();
			postInstantiate();
			batchLoader = batchSize > 1;

		}

		@Override
		protected boolean isSingleRowLoader() {
			return !batchLoader;
		}

		@Override
		public int[][] getCompositeKeyManyToOneTargetIndices() {
			return compositeKeyManyToOneTargetIndices;
		}
	}
}
