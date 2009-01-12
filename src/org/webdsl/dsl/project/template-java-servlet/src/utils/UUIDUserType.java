package utils;

import java.io.IOException;
import java.io.Serializable ;
import java.sql.PreparedStatement ;
import java.sql.ResultSet ;
import java.sql.SQLException ;
import java.sql.Types ;
import java.util.UUID ;

import org.hibernate.type.SerializationException;

import org.hibernate.HibernateException ;
import org.hibernate.usertype.UserType ;
//http://www.bigsoft.co.uk/blog/index.php/2008/11/01/java-util-uuid-primary-keys-in-hibernate
//changed to work with varchar(16) field in db
public class UUIDUserType implements UserType
{

	private static final String CAST_EXCEPTION_TEXT = " cannot be cast to a java.util.UUID." ;

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#assemble(java.io.Serializable,
	 * java.lang.Object)
	 */
	public Object assemble (Serializable cached, Object owner) throws HibernateException
	{

		if (!String.class.isAssignableFrom (cached.getClass ()))
		{
			return null ;
		}

		return UUID.fromString ((String) cached) ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#deepCopy(java.lang.Object)
	 */
	public Object deepCopy (Object value) throws HibernateException
	{

		if (!UUID.class.isAssignableFrom (value.getClass ()))
		{
			throw new HibernateException (value.getClass ().toString () + CAST_EXCEPTION_TEXT) ;
		}

		UUID other = (UUID) value ;

		return UUID.fromString (other.toString ()) ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#disassemble(java.lang.Object)
	 */
	public Serializable disassemble (Object value) throws HibernateException
	{

		return value.toString () ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#equals(java.lang.Object,
	 * java.lang.Object)
	 */
	public boolean equals (Object x, Object y) throws HibernateException
	{
		if (x == y)
			return true ;

		if(x == null  ||  y == null)
			return false;

		if (!UUID.class.isAssignableFrom (x.getClass ()))
		{
			throw new HibernateException (x.getClass ().toString () + CAST_EXCEPTION_TEXT) ;
		}
		else if (!UUID.class.isAssignableFrom (y.getClass ()))
		{

			throw new HibernateException (y.getClass ().toString () + CAST_EXCEPTION_TEXT) ;
		}

		UUID a = (UUID) x ;
		UUID b = (UUID) y ;

		return a.equals (b) ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#hashCode(java.lang.Object)
	 */
	public int hashCode (Object x) throws HibernateException
	{
		if (!UUID.class.isAssignableFrom (x.getClass ()))
		{
			throw new HibernateException (x.getClass ().toString () + CAST_EXCEPTION_TEXT) ;
		}

		return x.hashCode () ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#isMutable()
	 */
	public boolean isMutable ()
	{

		return false ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#nullSafeGet(java.sql.ResultSet,
	 * java.lang.String[], java.lang.Object)
	 */
	public Object nullSafeGet (ResultSet rs, String[] names, Object owner) throws HibernateException,
	SQLException
	{
		//System.out.println("get start");
		byte[] value;

		value = rs.getBytes(names[0]);//rs.getString (names[0]) ;

		if (value == null)
		{
			return null ;
		}
		else
		{
			//System.out.println("get length: "+value.length);
			try {
				java.io.DataInputStream dis = new java.io.DataInputStream(new java.io.ByteArrayInputStream(value));

				long most=(Long)dis.readLong();
				long least=(Long)dis.readLong();
				UUID temp = new UUID(most,least);


				//System.out.println("get success");
				return temp;
			} catch (IOException e) {
				e.printStackTrace();
				//System.out.println("get fail");
				return null;
			} 
		}


	}

	/*
	 * (non-Javadoc)
	 * @see
	 * org.hibernate.usertype.UserType#nullSafeSet(java.sql.PreparedStatement,
	 * java.lang.Object, int)
	 */
	public void nullSafeSet (PreparedStatement st, Object value, int index)
	throws HibernateException, SQLException
	{
		// System.out.println("set start");
		if (value == null)
		{
			st.setNull (index, theType) ;
			//System.out.println("set success null");
			return ;
		}

		if (!UUID.class.isAssignableFrom (value.getClass ()))
		{
			//	System.out.println("set fail");
			throw new HibernateException (value.getClass ().toString () + CAST_EXCEPTION_TEXT) ;
		}

		java.io.ByteArrayOutputStream bytesOutput = new java.io.ByteArrayOutputStream();
		// java.io.ObjectInputStream valueInput = null;

		try {
			//java.io.ObjectOutputStream valueOutput = new java.io.ObjectOutputStream(bytesOutput);

			UUID temp = (UUID) value;

			//bytesOutput.write(new Long(temp.getMostSignificantBits()).);

			//ByteArrayOutputStream bos = new ByteArrayOutputStream();  
			java.io.DataOutputStream dos = new java.io.DataOutputStream(bytesOutput);  
			dos.writeLong(temp.getMostSignificantBits());  
			dos.writeLong(temp.getLeastSignificantBits());  
			dos.flush();  
			//byte[] data = bytesOutput.toByteArray(); 

			//valueOutput.writeObject();
			// valueOutput.writeObject(temp.getLeastSignificantBits());

			//valueInput = new java.io.ObjectInputStream(new java.io.ByteArrayInputStream(bytesOutput.toByteArray()));//rs.getString (names[0]) ;
			//System.out.println("set length: "+bytesOutput.toByteArray().length);
		} catch (IOException e) {
			//System.out.println("set fail");
			e.printStackTrace();
		}
		//System.out.println("set success");
		//st.setString (index, value.toString ()) ;
		st.setBytes(index, bytesOutput.toByteArray());
		//(index, valueInput, theLength);
		// st.set
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#replace(java.lang.Object,
	 * java.lang.Object, java.lang.Object)
	 */
	public Object replace (Object original, Object target, Object owner) throws HibernateException
	{

		if (!UUID.class.isAssignableFrom (original.getClass ()))
		{
			throw new HibernateException (original.getClass ().toString () + CAST_EXCEPTION_TEXT) ;
		}

		return UUID.fromString (original.toString ()) ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#returnedClass()
	 */
	@SuppressWarnings("unchecked")
	public Class returnedClass ()
	{

		return UUID.class ;
	}

	/*
	 * (non-Javadoc)
	 * @see org.hibernate.usertype.UserType#sqlTypes()
	 */
	public int[] sqlTypes ()
	{
		//System.out.println("sqlTypes: "+theType);
		return new int[] { theType } ;
	}

	public static final int theType = org.hibernate.Hibernate.STRING.sqlType(); // use db independent type of hibernate

}


