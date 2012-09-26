package utils;

import java.io.Serializable;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.engine.SessionFactoryImplementor;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.engine.LoadQueryInfluencers;
import org.hibernate.loader.Loader;
import org.hibernate.persister.collection.CollectionPersister;
import org.hibernate.persister.collection.QueryableCollection;
import org.hibernate.util.ArrayHelper;
import org.hibernate.loader.collection.CollectionInitializer;
import org.hibernate.loader.collection.OneToManyLoader;
import org.hibernate.loader.collection.BasicCollectionLoader;

// An alternative implementation of org.hibernate.loader.collection.BatchingCollectionInitializer
// This implementation supports initializing a specific batch
public class BatchingCollectionInitializer implements CollectionInitializer {
	private final Loader[] loaders;
	private final int[] batchSizes;
	private final CollectionPersister collectionPersister;

	private final int maxBatchSizeCfg; // The configured max batch size
	// In org.hibernate.loader.collection.BatchingCollectionInitializer this is equal to batchSizes[0]
	// In this implementation we require batchSizes[0] to be at least DEFAULT_MAX_BATCH_SIZE
	// maxBatchSizeCfg is used to determine behavior when no specific batch is provided

	public static final int DEFAULT_MAX_BATCH_SIZE = 10; 

	public BatchingCollectionInitializer(CollectionPersister collPersister, int[] batchSizes, Loader[] loaders, int maxBatchSizeCfg) {
		this.loaders = loaders;
		this.batchSizes = batchSizes;
		this.collectionPersister = collPersister;
		this.maxBatchSizeCfg = maxBatchSizeCfg;
	}

	public CollectionPersister getCollectionPersister() {
		return collectionPersister;
	}

	public Loader[] getLoaders() {
		return loaders;
	}

	public int[] getBatchSizes() {
		return batchSizes;
	}

	public void initialize(Serializable id, SessionImplementor session)
	throws HibernateException {
		
		if(maxBatchSizeCfg > 1) { // The default batch fetch implementation, only performed if maxBatchSize was configured
			Serializable[] batch = session.getPersistenceContext().getBatchFetchQueue()
				.getCollectionBatch( collectionPersister, id, maxBatchSizeCfg, session.getEntityMode() );
			
			for ( int i=0; i<batchSizes.length-1; i++) {
				final int smallBatchSize = batchSizes[i];
				if ( batch.length >= smallBatchSize && batch[smallBatchSize-1]!=null ) {
					Serializable[] smallBatch = new Serializable[smallBatchSize];
					System.arraycopy(batch, 0, smallBatch, 0, smallBatchSize);
					loaders[i].loadCollectionBatch( session, smallBatch, collectionPersister.getKeyType() );
					return; //EARLY EXIT!
				}
			}
		}
		
		loaders[batchSizes.length-1].loadCollection( session, id, collectionPersister.getKeyType() );

	}

	public void initializeBatch(Serializable[] batch, SessionImplementor session)
	throws HibernateException {

		if(batch == null || batch.length == 0 || batchSizes.length < 2) {
			//System.out.println("early exit");
			return; // Exit if no batch was specified or if maxBatchSize was smaller than 2
		}

		int loaded = 0;
		int remaining = batch.length;
		for ( int i=0; i<batchSizes.length-1; i++) { // Iterate batch queries from large to small
			final int smallBatchSize = batchSizes[i];
			Serializable[] smallBatch = new Serializable[smallBatchSize];
			while ( remaining >= smallBatchSize ) { // While the current batch query can be filled with remaining collection
				//System.out.println("batch " + smallBatchSize + " / " + remaining);
				System.arraycopy(batch, loaded, smallBatch, 0, smallBatchSize);
				loaders[i].loadCollectionBatch( session, smallBatch, collectionPersister.getKeyType() );
				loaded += smallBatchSize;
				remaining -= smallBatchSize;
			}
		}

		// The last collections must be fetched one by one, because the smallest batch query requires more collections
		while(remaining > 0) {
//			System.out.println("batch 1 / " + remaining);
			loaders[batchSizes.length-1].loadCollection( session, batch[loaded], collectionPersister.getKeyType() );
			loaded++;
			remaining--;
		}
//		System.out.println("exit");

	}

	public static BatchingCollectionInitializer createBatchingOneToManyInitializer(
			final QueryableCollection persister,
			final int maxBatchSize,
			final SessionFactoryImplementor factory,
			final LoadQueryInfluencers loadQueryInfluencers) throws MappingException {
		int[] batchSizesToCreate = ArrayHelper.getBatchSizes(maxBatchSize > DEFAULT_MAX_BATCH_SIZE ? maxBatchSize : DEFAULT_MAX_BATCH_SIZE);
		Loader[] loadersToCreate = new Loader[ batchSizesToCreate.length ];
		for ( int i=0; i<batchSizesToCreate.length; i++ ) {
			loadersToCreate[i] = new OneToManyLoader( persister, batchSizesToCreate[i], factory, loadQueryInfluencers );
		}
		return new BatchingCollectionInitializer( persister, batchSizesToCreate, loadersToCreate, maxBatchSize );
	}

	public static BatchingCollectionInitializer createBatchingCollectionInitializer(
			final QueryableCollection persister,
			final int maxBatchSize,
			final SessionFactoryImplementor factory,
			final LoadQueryInfluencers loadQueryInfluencers) throws MappingException {
		int[] batchSizesToCreate = ArrayHelper.getBatchSizes(maxBatchSize > DEFAULT_MAX_BATCH_SIZE ? maxBatchSize : DEFAULT_MAX_BATCH_SIZE);
		Loader[] loadersToCreate = new Loader[ batchSizesToCreate.length ];
		for ( int i=0; i<batchSizesToCreate.length; i++ ) {
			loadersToCreate[i] = new BasicCollectionLoader( persister, batchSizesToCreate[i], factory, loadQueryInfluencers );
		}
		return new BatchingCollectionInitializer(persister, batchSizesToCreate, loadersToCreate, maxBatchSize);
	}
}
