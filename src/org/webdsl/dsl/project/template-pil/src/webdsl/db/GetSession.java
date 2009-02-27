package webdsl.db;

import org.hibernate.*;
import org.hibernate.cfg.*;
import java.util.Properties;
import javax.persistence.*;

public class GetSession {
  private static SessionFactory sessionFactory = null;
  public static DatabaseSession getSession() {
    if(sessionFactory == null) {
      /*Properties p = new Properties();
      p.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL5InnoDBDialect");
      p.setProperty("hibernate.connection.driver_class", "com.mysql.jdbc.Driver");
      p.setProperty("hibernate.connection.url", "jdbc:mysql://localhost/" + webdsl.db.DatabaseName.databaseName + "?useServerPrepStmts=false");
      p.setProperty("hibernate.connection.username", webdsl.db.DatabaseUsername.databaseUsername);
      p.setProperty("hibernate.connection.password", webdsl.db.DatabasePassword.databasePassword);
      //p.setProperty("hibernate.connection.pool_size", "1");

      p.setProperty("hibernate.current_session_context_class", "thread");
      p.setProperty("hibernate.cache.provider_class", "org.hibernate.cache.NoCacheProvider");
      p.setProperty("hibernate.show_sql", "true");
      p.setProperty("hibernate.hbm2ddl.auto", "update");// update / create-drop
*/
      AnnotationConfiguration annotationConfiguration = new AnnotationConfiguration();

      //annotationConfiguration.addPackage("datamodel");
      /*
      for(pil.reflect.Class c : webdsl.db.DbEntities.dbEntities) {
        annotationConfiguration.addAnnotatedClass(DatabaseSession.classToClass(c));
      }
      */

      //annotationConfiguration.addProperties(p);
      sessionFactory = annotationConfiguration.buildSessionFactory();
    }
    return new DatabaseSession(sessionFactory.getCurrentSession());
  }
}
