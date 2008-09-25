package utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.faces.convert.ConverterException;


public final class Encoders {
    public static String encodeTemplateId(String name, Object[] args,int counter)
    {
        try{
            // Create a Message Digest from a Factory method 
            MessageDigest md = MessageDigest.getInstance("MD5");

            // Create the message
            byte[] msg = name.getBytes();

            // Update the message digest with some more bytes
            // This can be performed multiple times before creating the hash
            md.update(msg);
            //for(Object o:args)
            //    md.update(o.toString().getBytes());
            md.update((""+counter).getBytes());

            // Create the digest from the message
            byte[] messageDigest = md.digest();

            BigInteger number = new BigInteger(1,messageDigest);

            return number.toString(16);

        }
        catch(NoSuchAlgorithmException e)
        {
            System.out.println("MD5 not available: "+e.getMessage());
            return null;
        }
    }
}
