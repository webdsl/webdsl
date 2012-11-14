package utils;

import java.util.List;

import org.hibernate.FlushMode;
import org.hibernate.Session;
import org.hibernate.Transaction;


public class HibernateTransactionHelper {
	
	public static List<ValidationException> commitAndStartNewTransaction() {
	    List<utils.ValidationException> exceptions = new java.util.LinkedList<utils.ValidationException>();		
	    Session hibSession = HibernateUtil.getCurrentSession();
		Transaction existingTransaction = hibSession.getTransaction();
//		hibSession.flush();
		boolean isValid = true;
		try{
			ThreadLocalPage.get().validateEntitiesAfterAction();
		}catch(utils.ValidationException ve){
			exceptions.add(ve);
            isValid = false;
            ThreadLocalPage.get().setValidated(false);
        } catch(utils.MultipleValidationExceptions ve){
            for(utils.ValidationException vex : ve.getValidationExceptions()){
            	exceptions.add(vex);
            }
            isValid = false;
            ThreadLocalPage.get().setValidated(false);
          }
		try{
			if (!isValid) {
				existingTransaction.rollback();
				System.out.println("rollback");
			} else {
				existingTransaction.commit();
				System.out.println("commit");
			}
		} catch (Exception ex) {
			System.out.println("exception occured: " + ex.getMessage());
	        ex.printStackTrace();
	        existingTransaction.rollback();
		} finally {
			HibernateUtil.getCurrentSession().close();
			Session newSession = ThreadLocalPage.get().openNewTransactionThroughGetCurrentSession();
			newSession.setFlushMode(FlushMode.COMMIT);
			ThreadLocalPage.get().cleareEntitiesValidatedAfterAction();
			ThreadLocalPage.get().initVarsAndArgs();
		}
		return exceptions;
	}
}
