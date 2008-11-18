package test;
import org.hibernate.*;
import org.hibernate.cfg.*;
import java.util.Properties;
import javax.persistence.*;

public class SetupHibernate {
	public static void main(String[] args) {
	    Properties p = new Properties();
	    p.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQL5InnoDBDialect");
	    p.setProperty("hibernate.connection.driver_class", "com.mysql.jdbc.Driver");
	    p.setProperty("hibernate.connection.url", "jdbc:mysql://localhost/querylist?useServerPrepStmts=false");
	    p.setProperty("hibernate.connection.username", "root");
	    p.setProperty("hibernate.connection.password", "");
	    p.setProperty("hibernate.show_sql", "true");
	    AnnotationConfiguration annotationConfiguration = new AnnotationConfiguration();

	    annotationConfiguration.addPackage("test");
	    annotationConfiguration.addAnnotatedClass(test.User.class);
	    annotationConfiguration.addAnnotatedClass(test.Message.class);

	    annotationConfiguration.addProperties(p);
		SessionFactory sessionFactory = annotationConfiguration.buildSessionFactory();
		Session hibSession = sessionFactory.getCurrentSession();
		hibSession.beginTransaction();
	}
}
