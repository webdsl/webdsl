package utils;

import java.io.Serializable;
import java.util.Arrays;

import org.hibernate.EmptyInterceptor;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.event.FlushEntityEvent;
import org.hibernate.event.LoadEvent;
import org.hibernate.event.LoadEventListener;
import org.hibernate.event.SaveOrUpdateEvent;
import org.hibernate.event.def.DefaultFlushEntityEventListener;
import org.hibernate.event.def.DefaultLoadEventListener;
import org.hibernate.event.def.DefaultSaveOrUpdateEventListener;
import org.hibernate.type.Type;
import org.webdsl.WebDSLEntity;
import org.webdsl.logging.Logger;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = getSessionFactoryUsingReflection();

    //Session factory is initialized and configured by generated code, we therefore use reflection.
    private static SessionFactory getSessionFactoryUsingReflection(){
        try {
            return (SessionFactory)Class.forName("utils.HibernateUtilConfigured").getDeclaredMethod("getConfiguredSessionFactory").invoke(null);
        } catch (Throwable e) {
            Logger.fatal(e);
            return null;
        }
    }

    public static SessionFactory getSessionFactory(){
        return sessionFactory;
    }

    public static Session getCurrentSession(){
        return getSessionFactory().getCurrentSession();
    }

    protected static class NarrowProxyByReusingImplementationLoadEventListener extends DefaultLoadEventListener {
        @Override
        protected Object proxyOrLoad(
            final LoadEvent event,
            final org.hibernate.persister.entity.EntityPersister persister,
            final org.hibernate.engine.EntityKey keyToLoad,
            final LoadEventListener.LoadType options) {
          if ( persister.hasProxy() ) {
            final org.hibernate.engine.PersistenceContext persistenceContext = event.getSession().getPersistenceContext();
            Object proxy = persistenceContext.getProxy(keyToLoad);
            if ( proxy instanceof org.hibernate.proxy.HibernateProxy && !((org.hibernate.proxy.HibernateProxy)proxy).getHibernateLazyInitializer().isUninitialized() ) {
              // Here we know that PersistenceContext.narrowProxy is going to be called
              Class<?> concreteProxyClass = persister.getConcreteProxyClass( event.getSession().getEntityMode() );
              boolean alreadyNarrow = concreteProxyClass.isAssignableFrom( proxy.getClass() );
              if(alreadyNarrow) return proxy; // If the existing proxy is already narrow then we do not need to create a new proxy
              Object implementation = ((org.hibernate.proxy.HibernateProxy)proxy).getHibernateLazyInitializer().getImplementation();
              boolean implementationAlreadyNarrow = concreteProxyClass.isAssignableFrom( implementation.getClass() );
              if(implementationAlreadyNarrow) { // The implementation is narrow, but the proxy was not, so create a new one, but reuse the existing implementation
                Object newProxy = persister.createProxy( keyToLoad.getIdentifier(), event.getSession() );
                if(newProxy instanceof org.hibernate.proxy.HibernateProxy) {
                  ((org.hibernate.proxy.HibernateProxy)newProxy).getHibernateLazyInitializer().setImplementation(implementation);
                  persistenceContext.addProxy(keyToLoad, newProxy); //overwrite old proxy
                  return newProxy;
                }
              }
            }
          }
          return super.proxyOrLoad(event, persister, keyToLoad, options);
        }
      }
      // references that will be implicitly stored in the db need version set to at least 1 as well to indicate a persisted entity
      @SuppressWarnings("serial")
      protected static class SetVersionSaveOrUpdateEventListener extends DefaultSaveOrUpdateEventListener
      {
        public void onSaveOrUpdate(SaveOrUpdateEvent event)  throws HibernateException
        {
          setVersion(event.getObject());
          super.onSaveOrUpdate(event);
        }

        public void setVersion(Object o)
        {

          if(org.hibernate.Hibernate.isInitialized(o) && o instanceof WebDSLEntity)
          {
            WebDSLEntity we = (WebDSLEntity)o;
            if(we.getVersion() <= 0)
            {
              we.setVersion(1);
            }
          }
        }

      }

      //register which objects need to be validated at the end of an action
      @SuppressWarnings("serial")
      protected static class SetValidationEventListener extends DefaultFlushEntityEventListener
      {
          public void onFlushEntity(FlushEntityEvent event) throws HibernateException
          {
            validate(event.getEntity());
            super.onFlushEntity(event);
          }

          public void validate(Object o)
          {
              if(o instanceof WebDSLEntity)
              {
                  WebDSLEntity we = (WebDSLEntity)o;
                  AbstractPageServlet aps = ThreadLocalPage.get();
                  if(aps != null){
//                    System.out.println("addToValidate: "+we.getName());
                    aps.addEntityToBeValidated(we);
                  }
              }
          }
      }

      protected static class FastAutoFlushEventListener implements org.hibernate.event.AutoFlushEventListener {
        public void onAutoFlush(org.hibernate.event.AutoFlushEvent event) throws HibernateException {
          if(!ThreadLocalPage.isReadOnly()){
		      if(!event.getSession().getFlushMode().lessThan(org.hibernate.FlushMode.AUTO)) {
		    	  //org.webdsl.logging.Logger.info("onAutoFlush");
		        event.getSession().flush();
		        event.getSession().setFlushMode(org.hibernate.FlushMode.COMMIT);
		      }
          }
        }
      }

      protected static class WebDSLInterceptor extends EmptyInterceptor {
        @Override
        public int[] findDirty(Object entity, java.io.Serializable id, Object[] currentState, Object[] previousState, String[] propertyNames, org.hibernate.type.Type[] types) {
          if(entity instanceof WebDSLEntity && !((WebDSLEntity)entity).isChanged()) {
            return new int[0]; // Entity is not dirty
          }
          return null; // Use default dirty checking
        }
        public boolean onFlushDirty(Object entity, Serializable id, Object[] currentState, Object[] previousState, String[] propertyNames, Type[] types)
        {
          if(org.hibernate.Hibernate.isInitialized(entity) && entity instanceof WebDSLEntity)
          {
            setValue(currentState, propertyNames, "_modified", new java.util.Date());
          }
          return true;
        }

        public boolean onSave(Object entity, Serializable id, Object[] state, String[] propertyNames, Type[] types)
        {
          if(org.hibernate.Hibernate.isInitialized(entity) && entity instanceof WebDSLEntity)
          {
            setValue(state, propertyNames, "_created", new java.util.Date());
            setValue(state, propertyNames, "_modified", new java.util.Date());
          }
          return true;
        }

        private void setValue(Object[] state, String[] propertyNames, String propertyToSet, Object value)
        {
          int index = Arrays.asList(propertyNames).indexOf(propertyToSet);
          if (index >= 0)
          {
            state[index] = value;
          }
        }
      }



}
