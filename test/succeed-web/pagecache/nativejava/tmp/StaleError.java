package tmp;
public class StaleError{

  public static boolean firstTime = true;

  public static int error(){
    if(firstTime){
      firstTime = false;
      utils.HibernateUtilConfigured.getSessionFactory().getCurrentSession().close();
      throw new org.hibernate.StaleObjectStateException("1",new Integer(1));
    }
    return 1;
  }

}