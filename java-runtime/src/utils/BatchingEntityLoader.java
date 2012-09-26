package utils;

import java.io.Serializable;
import org.hibernate.LockMode;
import org.hibernate.LockOptions;
import org.hibernate.MappingException;
import org.hibernate.engine.LoadQueryInfluencers;
import org.hibernate.engine.SessionFactoryImplementor;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.loader.Loader;
import org.hibernate.loader.entity.EntityLoader;
import org.hibernate.loader.entity.UniqueEntityLoader;
import org.hibernate.persister.entity.OuterJoinLoadable;
import org.hibernate.persister.entity.EntityPersister;
import org.hibernate.type.Type;
import org.hibernate.util.ArrayHelper;

public class BatchingEntityLoader {

	public static final int DEFAULT_MAX_BATCH_SIZE = 10; 

	private final Loader[] loaders;
	private final int[] batchSizes;
	private final EntityPersister persister;
	private final Type idType;
	//private Serializable[] nextBatch = null;

	public BatchingEntityLoader(EntityPersister persister, int[] batchSizes, Loader[] loaders) {
		this.batchSizes = batchSizes;
		this.loaders = loaders;
		this.persister = persister;
		idType = persister.getIdentifierType();
	}

	public static BatchingEntityLoader createBatchingEntityLoader(
			final OuterJoinLoadable persister,
			final SessionFactoryImplementor factory) throws MappingException {
			int[] batchSizesToCreate = ArrayHelper.getBatchSizes(DEFAULT_MAX_BATCH_SIZE);
      //System.out.print("created loader");
			Loader[] loadersToCreate = new Loader[ batchSizesToCreate.length ];
			for ( int i=0; i<batchSizesToCreate.length; i++ ) {
				loadersToCreate[i] = new EntityLoader(persister, batchSizesToCreate[i], LockMode.NONE, factory, LoadQueryInfluencers.NONE);
//        System.out.print(", " + batchSizesToCreate[i]);
			}
//      System.out.println();
			return new BatchingEntityLoader(persister, batchSizesToCreate, loadersToCreate);
	}
/*
	private Object getObjectFromList(java.util.List results, Serializable id, SessionImplementor session) {
		// get the right object from the list ... would it be easier to just call getEntity() ??
		java.util.Iterator iter = results.iterator();
		while ( iter.hasNext() ) {
			Object obj = iter.next();
			final boolean equal = idType.isEqual( 
					id, 
					session.getContextEntityIdentifier(obj), 
					session.getEntityMode(), 
					session.getFactory() 
			);
			if ( equal ) return obj;
		}
		return null;
	}

	public Object load(Serializable id, Object optionalObject, SessionImplementor session) {
		// this form is deprecated!
		System.out.println("loadfrom deprecated " + persister.getEntityName());
		return load( id, optionalObject, session, LockOptions.NONE );
	}

	public Object load(Serializable id, Object optionalObject, SessionImplementor session, LockOptions lockOptions) {
		System.out.println("loadfrom " + persister.getEntityName());
		if(nextBatch == null || nextBatch.length <= 1) {
			return ( (UniqueEntityLoader) loaders[batchSizes.length-1] ).load(id, optionalObject, session, lockOptions);
		}
    System.out.println("batch has id?");
		for(int i = 0; i < nextBatch.length; i++) {
			if(nextBatch[i].equals(id)) break;
			if(i == nextBatch.length - 1) return ( (UniqueEntityLoader) loaders[batchSizes.length-1] ).load(id, optionalObject, session, lockOptions); 
		}
		int loaded = 0;
		int remaining = nextBatch.length;
		Object rtn = null;
		for ( int i=0; i<batchSizes.length-2; i++) { // Iterate batch queries from large to small
			final int smallBatchSize = batchSizes[i];
			Serializable[] smallBatch = new Serializable[smallBatchSize];
			while ( remaining >= smallBatchSize ) { // While the current batch query can be filled with remaining collection
				System.out.println("batch " + smallBatchSize + " / " + remaining);
				System.arraycopy(nextBatch, loaded, smallBatch, 0, smallBatchSize);
				final java.util.List results = loaders[i].loadEntityBatch(
						session, 
						smallBatch, 
						idType, 
						optionalObject, 
						persister.getEntityName(), 
						id, 
						persister,
						lockOptions
				);
				System.out.println("LockOption: " + lockOptions.getLockMode());
				if(rtn == null) rtn = getObjectFromList(results, id, session);
			}
		}

		// The last collections must be fetched one by one, because the smallest batch query requires more collections
		while(remaining > 0) {
			System.out.println("batch 1 / " + remaining);
			Object res = ( (UniqueEntityLoader) loaders[batchSizes.length-1] ).load(nextBatch[loaded], null, session, LockOptions.NONE);
			if(nextBatch[loaded].equals(id)) rtn = res;
			loaded++;
			remaining--;
		}
		return rtn;
	}
*/
	public void loadBatch(Serializable[] batch, SessionImplementor session) {
    //System.out.println("setting next batch");
		//nextBatch = batch;
		if(batch == null || batch.length == 0 || batchSizes.length < 2) {
//			System.out.println("early exit");
			return; // Exit if no batch was specified or if maxBatchSize was smaller than 2
		}

		if(java.lang.reflect.Proxy.isProxyClass( session.getClass() ) ) {
//			System.out.println("Need unwrap");
			// We need to unwrap the session at this point, because otherwise the wrapper is seen as a different session
			if(session instanceof org.hibernate.Session) {
				Object realSession = ((org.hibernate.Session)session).getSession(session.getEntityMode());
				if(realSession instanceof SessionImplementor) {
					session = (SessionImplementor)realSession;
				}
				else {
//					System.out.println("Could not unwrap: realSession!=SessionImplementor");
					return;
				}
			}
			else {
//				System.out.println("Could not unwrap: session!=org.hibernate.Session");
				return;
			}
		}

//		System.out.println("batching " + persister.getEntityName());
		int loaded = 0;
		int remaining = batch.length;
		for ( int i=0; i<batchSizes.length-1; i++) { // Iterate batch queries from large to small
			final int smallBatchSize = batchSizes[i];
//      System.out.println("Trying batchsize " + smallBatchSize + " need " + remaining + " fit=" + (remaining >= smallBatchSize));
			Serializable[] smallBatch = new Serializable[smallBatchSize];
			while ( remaining >= smallBatchSize ) { // While the current batch query can be filled with remaining collection
				//System.out.println("batch " + smallBatchSize + " / " + remaining);
				System.arraycopy(batch, loaded, smallBatch, 0, smallBatchSize);
        try{
				loaders[i].loadEntityBatch(
						session, 
						smallBatch, 
						idType, 
						null, 
						persister.getEntityName(), 
						null, 
						persister,
						LockOptions.NONE
				);
        }catch(Exception ex){ex.printStackTrace();}
//finally{System.out.println("batch complete");}
				loaded += smallBatchSize;
				remaining -= smallBatchSize;
			}
		}

		// The last collections must be fetched one by one, because the smallest batch query requires more collections
		while(remaining > 0) {
			//System.out.println("batch 1 / " + remaining);
			( (UniqueEntityLoader) loaders[batchSizes.length-1] ).load(batch[loaded], null, session, LockOptions.NONE);
			loaded++;
			remaining--;
		}
//		System.out.println("exit");
	}
}
