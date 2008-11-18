package test;

import static org.webdsl.querylist.Filters.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.webdsl.querylist.ParameterBindings;
import org.webdsl.querylist.MemoryQueryList;
import org.webdsl.querylist.QueryList;

public class TestQueryList {
	public static void testHibernate() {
		Properties p = new Properties();
		p.setProperty("hibernate.dialect",
				"org.hibernate.dialect.MySQL5InnoDBDialect");
		p.setProperty("hibernate.connection.driver_class",
				"com.mysql.jdbc.Driver");
		p.setProperty("hibernate.connection.url",
				"jdbc:mysql://localhost/querylist?useServerPrepStmts=false");
		p.setProperty("hibernate.connection.username", "root");
		p.setProperty("hibernate.connection.password", "");
		p.setProperty("hibernate.show_sql", "true");
		p.setProperty("hibernate.current_session_context_class", "thread");
		p.setProperty("hibernate.cache.provider_class",
				"org.hibernate.cache.NoCacheProvider");
		p.setProperty("hibernate.hbm2ddl.auto", "create-drop");
		AnnotationConfiguration annotationConfiguration = new AnnotationConfiguration();

		annotationConfiguration.addPackage("test");
		annotationConfiguration.addAnnotatedClass(test.User.class);
		annotationConfiguration.addAnnotatedClass(test.Message.class);

		annotationConfiguration.addProperties(p);
		SessionFactory sessionFactory = annotationConfiguration
				.buildSessionFactory();
		Session hibSession = sessionFactory.getCurrentSession();
		hibSession.beginTransaction();

		User zef = new User("Zef", 25);
		User piet = new User("Piet", 50);
		hibSession.save(zef);
		hibSession.save(piet);
		Message m = new Message();
		m.setText("Cool!");
		m.setAuthor(zef);
		hibSession.save(m);
		m = new Message();
		m.setText("Vet!");
		m.setAuthor(piet);
		hibSession.save(m);
		
		List<Object> bindings = new ArrayList<Object>();
		Query query = hibSession.createQuery("from Message item where " + and(eq("author", zef), neq("author.age", 50)).toHQL(bindings));
		for(int i = 0; i < bindings.size(); i++) {
			query.setParameter(i, bindings.get(i));
		}
		System.out.println(query.list());
		
		hibSession.getTransaction().commit();
	}

	public static void main(String[] args) {
		testLocal();
		testHibernate();
	}

	private static void testLocal() {
		QueryList<Message> list = new MemoryQueryList<Message>();
		User zef = new User("Zef", 25);
		User piet = new User("Piet", 50);
		Message m = new Message();
		m.setText("Cool!");
		m.setAuthor(zef);
		list.add(m);
		m = new Message();
		m.setText("Vet!");
		m.setAuthor(piet);
		list.add(m);

		list.addFilter(and(eq("author", zef), neq("author.age", 50)));
		List<Object> bindings = new ArrayList<Object>();
		System.out.println(and(eq("author", zef), neq("author.age", 50)).toHQL(
				bindings));
		System.out.println(list.list());
	}
}
