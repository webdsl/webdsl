package utils;

import java.util.Properties;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.config.Configuration;
import net.sf.ehcache.config.ConfigurationFactory;
import net.sf.ehcache.config.CacheConfiguration;
import org.hibernate.cache.CacheException;
import org.hibernate.cfg.Settings;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.net.MalformedURLException;
import java.net.URL;

public class EhCacheRegionFactory extends net.sf.ehcache.hibernate.EhCacheRegionFactory {
    private static final Logger LOG = LoggerFactory.getLogger(EhCacheRegionFactory.class);

    public static final String NET_SF_EHCACHE_REGION_PREFIX = "utils.ehcache.region.";

    public EhCacheRegionFactory(Properties prop) {
    	super(prop);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @SuppressWarnings("unchecked")
	public void start(Settings settings, Properties properties) throws CacheException {
        this.settings = settings;

        if (manager != null) {
            LOG.warn("Attempt to restart an already started EhCacheRegionFactory. Use sessionFactory.close() " +
                    " between repeated calls to buildSessionFactory. Using previously created EhCacheRegionFactory." +
                    " If this behaviour is required, consider using SingletonEhCacheRegionFactory.");
            return;
        }

        try {
            String configurationResourceName = null;
            Configuration configuration = null;
            if (properties != null) {
                configurationResourceName = (String) properties.get(NET_SF_EHCACHE_CONFIGURATION_RESOURCE_NAME);
            }
            if (configurationResourceName == null || configurationResourceName.length() == 0) {
            	configuration = ConfigurationFactory.parseConfiguration();
            } else {
                URL url;
                try {
                    url = new URL(configurationResourceName);
                } catch (MalformedURLException e) {
                    url = loadResource(configurationResourceName);
                }
                configuration = ConfigurationFactory.parseConfiguration(url); // HibernateUtil.loadAndCorrectConfiguration(url) not visible and only needed for terracotta cluster
            }

            // At this point the configuration has been parsed as usual
            // Now we override properties that are defined in hibernate.properties

            overrideCacheConfiguration(properties, configuration.getDefaultCacheConfiguration(), net.sf.ehcache.Cache.DEFAULT_CACHE_NAME);

            java.util.HashSet<String> regions = new java.util.HashSet<String>(); 
            java.util.Enumeration enumeration = properties.propertyNames();
            while(enumeration.hasMoreElements()) {
            	String key = (String)enumeration.nextElement();
            	if(key.startsWith(NET_SF_EHCACHE_REGION_PREFIX)) {
            		int lstDot = key.lastIndexOf(".");
            		if(lstDot > NET_SF_EHCACHE_REGION_PREFIX.length()) {
            			String region = key.substring(NET_SF_EHCACHE_REGION_PREFIX.length(), lstDot);
            			if(!region.equals(net.sf.ehcache.Cache.DEFAULT_CACHE_NAME)) regions.add(region);
            		}
            	}
            }

            for(String region : regions) {
            	CacheConfiguration cacheConfig = configuration.getCacheConfigurations().get(region);
            	if(cacheConfig == null) {
            		cacheConfig = configuration.getDefaultCacheConfiguration().clone();
            		cacheConfig.setName(region);
            		overrideCacheConfiguration(properties, cacheConfig, region);
            		configuration.addCache(cacheConfig);
            	}
            	else {
            		overrideCacheConfiguration(properties, cacheConfig, region);
            	}
            }

            manager = new CacheManager(configuration);
            mbeanRegistrationHelper.registerMBean(manager, properties);
        } catch (net.sf.ehcache.CacheException e) {
            if (e.getMessage().startsWith("Cannot parseConfiguration CacheManager. Attempt to create a new instance of " +
                    "CacheManager using the diskStorePath")) {
                throw new CacheException("Attempt to restart an already started EhCacheRegionFactory. " +
                        "Use sessionFactory.close() between repeated calls to buildSessionFactory. " +
                        "Consider using SingletonEhCacheRegionFactory. Error from ehcache was: " + e.getMessage());
            } else {
                throw new CacheException(e);
            }
        }
    }

    protected void overrideCacheConfiguration(Properties properties, CacheConfiguration cacheConfig, String cacheName) {
    	String cachePrefix = NET_SF_EHCACHE_REGION_PREFIX + cacheName + ".";

    	if(properties.get(cachePrefix + "maxElementsInMemory") != null) {
    		int maxElementsInMemory = Integer.parseInt((String)properties.get(cachePrefix + "maxElementsInMemory"));
    		cacheConfig.setMaxElementsInMemory(maxElementsInMemory);
    	}

    	if(properties.get(cachePrefix + "eternal") != null) {
    		boolean eternal = Boolean.parseBoolean((String)properties.get(cachePrefix + "eternal"));
    		cacheConfig.setEternal(eternal);
    	}

    	if(properties.get(cachePrefix + "timeToIdleSeconds") != null) {
    		long timeToIdleSeconds = Long.parseLong((String)properties.get(cachePrefix + "timeToIdleSeconds"));
    		cacheConfig.setTimeToIdleSeconds(timeToIdleSeconds);
    	}

    	if(properties.get(cachePrefix + "timeToLiveSeconds") != null) {
    		long timeToLiveSeconds = Long.parseLong((String)properties.get(cachePrefix + "timeToLiveSeconds"));
    		cacheConfig.setTimeToLiveSeconds(timeToLiveSeconds);
    	}

    	if(properties.get(cachePrefix + "overflowToDisk") != null) {
    		boolean overflowToDisk = Boolean.parseBoolean((String)properties.get(cachePrefix + "overflowToDisk"));
    		cacheConfig.setOverflowToDisk(overflowToDisk);
    	}

    	if(properties.get(cachePrefix + "maxElementsOnDisk") != null){
    		int maxElementsOnDisk = Integer.parseInt((String)properties.get(cachePrefix + "maxElementsOnDisk"));
    		cacheConfig.setMaxElementsOnDisk(maxElementsOnDisk);
    	}

    	if(properties.get(cachePrefix + "diskPersistent") != null){
    		boolean diskPersistent = Boolean.parseBoolean((String)properties.get(cachePrefix + "diskPersistent"));
    		cacheConfig.setDiskPersistent(diskPersistent);
    	}

    	if(properties.get(cachePrefix + "diskExpiryThreadIntervalSeconds") != null) {
    		long diskExpiryThreadIntervalSeconds = Long.parseLong((String)properties.get(cachePrefix + "diskExpiryThreadIntervalSeconds"));
    		cacheConfig.setDiskExpiryThreadIntervalSeconds(diskExpiryThreadIntervalSeconds);
    	}

    	if(properties.get(cachePrefix + "diskExpiryThreadIntervalSeconds") != null) {
    		String memoryStoreEvictionPolicy = (String) properties.get(cachePrefix + "memoryStoreEvictionPolicy");
    		cacheConfig.setMemoryStoreEvictionPolicy(memoryStoreEvictionPolicy);
    	}
    }

}
