package utils;

import java.util.Properties;

import org.hibernate.*;
import org.hibernate.cfg.*;


public class HibernateUtil {
    private static final SessionFactory sessionFactory;
    private static final Properties p;

    static {

        try {
            p = new Properties();


            p.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL5InnoDBDialect");
            p.setProperty("hibernate.connection.driver_class", "com.mysql.jdbc.Driver");
            p.setProperty("hibernate.connection.url", "jdbc:mysql://@@DBSERVER@@/@@DBNAME@@?useServerPrepStmts=false");
            p.setProperty("hibernate.connection.username", "@@DBUSER@@");
            p.setProperty("hibernate.connection.password", "@@DBPASSWORD@@");
            //p.setProperty("hibernate.connection.pool_size", "1");

            p.setProperty("hibernate.current_session_context_class", "thread");
            p.setProperty("hibernate.cache.provider_class", "org.hibernate.cache.NoCacheProvider");
            p.setProperty("hibernate.show_sql", "true");
            p.setProperty("hibernate.hbm2ddl.auto", "@@DBMODE@@");// update / create-drop

            //System.out.println(p.toString());

            AnnotationConfiguration annotationConfiguration = new AnnotationConfiguration();

            //annotationConfiguration.addPackage("datamodel");

            //annotationConfiguration.addAnnotatedClass(User.class);

            annotationConfiguration.addProperties(p);

            sessionFactory = annotationConfiguration.buildSessionFactory();
            
        } catch (Throwable ex) {
            //			Log exception!
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }
    

    public static Properties getProperties() {
        return p;
    }
      

}