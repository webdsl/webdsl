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
		boolean isValid = true;
		try {
			try {
				hibSession.flush();
				ThreadLocalPage.get().validateEntities();
			} catch (utils.ValidationException ve) {
				exceptions.add(ve);
				isValid = false;
				ThreadLocalPage.get().setValidated(false);
			} catch (utils.MultipleValidationExceptions ve) {
				for (utils.ValidationException vex : ve
						.getValidationExceptions()) {
					exceptions.add(vex);
				}
				isValid = false;
				ThreadLocalPage.get().setValidated(false);
			}
			if (!isValid) {
				existingTransaction.rollback();
				// System.out.println("rollback");
			} else {
				existingTransaction.commit();
				// System.out.println("commit");
			}
		} catch (Exception ex) {
			org.webdsl.logging.Logger.error(ex);
			existingTransaction.rollback();
		} finally {
			Session newSession = ThreadLocalPage.get()
					.openNewTransactionThroughGetCurrentSession();
			newSession.setFlushMode(FlushMode.COMMIT);
			ThreadLocalPage.get().clearEntitiesToBeValidated();
			ThreadLocalPage.get().initVarsAndArgs();
		}
		return exceptions;
	}

	public static void rollbackAndStartNewTransaction() {
		Session hibSession = HibernateUtil.getCurrentSession();
		Transaction existingTransaction = hibSession.getTransaction();
		try {
			existingTransaction.rollback();
		} catch (Exception ex) {
			org.webdsl.logging.Logger.error(ex);
			ex.printStackTrace();
			existingTransaction.rollback();
		} finally {
			Session newSession = ThreadLocalPage.get()
					.openNewTransactionThroughGetCurrentSession();
			newSession.setFlushMode(FlushMode.COMMIT);
			ThreadLocalPage.get().clearEntitiesToBeValidated();
			ThreadLocalPage.get().initVarsAndArgs();
		}
	}

}
