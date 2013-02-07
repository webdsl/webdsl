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

	protected BatchingEntityLoader batchLoader = null;
	protected boolean hasSubselectLoadableCollections = false;

	public SingleTableEntityPersister(PersistentClass persistentClass,
			EntityRegionAccessStrategy cacheAccessStrategy,
			SessionFactoryImplementor factory,
			Mapping mapping) throws HibernateException {
		super(persistentClass, cacheAccessStrategy, factory, mapping);
		this.hasSubselectLoadableCollections = persistentClass.hasSubselectLoadableCollections();
		java.util.Iterator i = persistentClass.getSubclassIterator();
		while(!this.hasSubselectLoadableCollections && i.hasNext()) {
			this.hasSubselectLoadableCollections = ((org.hibernate.mapping.PersistentClass) i.next()).hasSubselectLoadableCollections();
		}
	}
	@Override
	protected void createLoaders() {
		super.createLoaders();
		if(utils.QueryOptimization.optimizationMode == 3) {
			batchLoader = BatchingEntityLoader.createBatchingEntityLoader(this, getFactory());
		}
	}

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

		if(utils.QueryOptimization.optimizationMode == 3) { // Guided batching with fixed batch size
			batchLoader.loadBatch(batch, session);
		} else {
			JoinEntityLoader loader = new JoinEntityLoader(this, batch.length, LockMode.NONE, session.getFactory(), session.getLoadQueryInfluencers(), joins);
			loader.loadEntityBatch(session, batch, getIdentifierType(), null, getEntityName(), null, this, LockOptions.NONE);
		}
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

		java.util.Set<Serializable> all = new java.util.HashSet<Serializable>(java.util.Arrays.asList(batch));
        JoinEntityLoader loader = new JoinEntityLoader(associatedPersister, columns, ukType, batch.length, LockMode.NONE, factory, session.getLoadQueryInfluencers(), null);
		java.util.List lst = loader.loadEntityBatch(session, batch, getIdentifierType(), null, associatedEntity, null, associatedPersister, LockOptions.NONE);
		// We register the EntityUniqueKeys with the persistence context, so the we can look them up later
		for(Object object : lst) {
			if(!(object instanceof org.hibernate.proxy.HibernateProxy)) {
				// Force proxy initialization
				Serializable objectId = associatedPersister.getIdentifier(object, session);
				org.hibernate.engine.EntityKey objectKey = new org.hibernate.engine.EntityKey( objectId, associatedPersister, entityMode );
				Object objectProxy = context.getProxy(objectKey);
				if(objectProxy instanceof org.hibernate.proxy.HibernateProxy) {
					((org.hibernate.proxy.HibernateProxy)objectProxy).getHibernateLazyInitializer().getImplementation();
				}
			}

			Object obj = associatedPersister.getPropertyValue(object, uniqueKeyPropertyName, entityMode);
			if(obj instanceof org.hibernate.proxy.HibernateProxy) { // We have to get the actual implementation, because getIdentifier does not work on proxies 
				obj = ((org.hibernate.proxy.HibernateProxy)obj).getHibernateLazyInitializer().getImplementation();
			}
			Serializable id = getIdentifier(obj, session); // Returns the identifier that was used to fetch the object (from batch)
			org.hibernate.engine.EntityUniqueKey euk = new org.hibernate.engine.EntityUniqueKey(
					associatedEntity, 
					uniqueKeyPropertyName,
					id,
					ukType,
					entityMode, 
					factory
			);
			context.addEntity( euk, object );
			all.remove(id);
		}
		// All remaining identifiers have a null value for the lazy property.
		// We need to initialize them directly, because we cannot register an euk for a null value.
		// The PersistenceContext uses a Map to store objects by euk, and the get() method returning null means the context has no object with that euk
		int propertyIndex = getEntityMetamodel().getPropertyIndex(propertyName);
		for(Serializable id : all) {
			org.hibernate.engine.EntityKey key = new org.hibernate.engine.EntityKey( id, this, entityMode );
			Object entity = context.getEntity(key);
			if(entity == null || !(entity instanceof org.webdsl.WebDSLEntity)) continue;
			if(((org.webdsl.WebDSLEntity)entity).removeUninitializedLazyProperty(propertyName)) {
				org.hibernate.engine.EntityEntry entry = context.getEntry(entity);
				if(entry == null) continue;
				final Object[] snapshot = entry.getLoadedState();
				if(snapshot == null) continue;
				setPropertyValue(entity, propertyIndex, null, session.getEntityMode());
				if(snapshot != null) {
					snapshot[ propertyIndex ] = type.deepCopy( null, session.getEntityMode(), factory );
				}
			}
		}
	}

	@Override
	public boolean hasSubselectLoadableCollections() {
		return hasSubselectLoadableCollections;
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
			        if(joinpaths == null || !joinpaths.contains(path.getFullPath())) {
			        	// Only perform these Hibernate checks if this join in not already enabled by a prefetch specification
						if ( !isJoinedFetchEnabledInMapping( metadataFetchMode, associationType )
								&& !isJoinFetchEnabledByProfile( persister, path, propertyNumber ) ) {
							return -1; // Do not include this join, because join fetching is not enabled by the Hibernate mapping or a fetching profile
							// This check can be ignored if the join is already present inside a prefetch specification
						}
						if ( isDuplicateAssociation( lhsTable, lhsColumns, associationType ) ) {
							return -1; // Do not include this join if already present inside the query
							// This is necessary for termination when a cycles are possible
							// For joins inside a prefetch specification this is not necessary, because they always have a finite number of joins
						}
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
