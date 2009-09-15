package utils;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import javax.faces.convert.ConverterException;
import org.apache.commons.codec.binary.Hex;

public final class Encoders {
    
    public static MessageDigest md = null;
    private static int hits = 0;
    
    public static String encodeTemplateId(String name, Object[] args,int counter)
    {
        //mw: append before update, and cache:
        String d = name + counter;
        try{
            hits+=1;
            // Create a Message Digest from a Factory method
            if (md == null)
                md = MessageDigest.getInstance("MD5");

            // Create the message
            // Update the message digest with some more bytes
            // This can be performed multiple times before creating the hash
            md.reset();
            md.update(d.getBytes());
            //for(Object o:args)
            //    md.update(o.toString().getBytes());

            // Create the digest from the message
            String s = new String(Hex.encodeHex(md.digest()));
            return s;
        }
        catch(NoSuchAlgorithmException e)
        {
            System.out.println("MD5 not available: "+e.getMessage());
            return null;
        }
    }
}
