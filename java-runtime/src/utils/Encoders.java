package utils;

import java.security.MessageDigest;

import org.apache.commons.codec.binary.Hex;

public final class Encoders {
    
    public static String encodeTemplateId(String name,/*String argsrep,*/ String templateContext, AbstractPageServlet threadLocalPage)
    {
        //System.out.println(name+" "+templateContext);
         
        // get a Message Digest from the threadlocal page object, that way, only one MD per thread is used (MD is not thread-safe)
        MessageDigest md = threadLocalPage.getMessageDigest();

        // Create the message
        // Update the message digest with some more bytes
        // This can be performed multiple times before creating the hash
        md.reset();
        md.update(name.getBytes());
        md.update(templateContext.getBytes());
        //md.update(argsrep.getBytes()); // removed arguments from deterministic id, arguments can change between phases

        org.webdsl.WebDSLEntity p = webdsl.generated.functions.principalAsEntity_.principalAsEntity_();
        if(p != null){
            md.update(p.getId().toString().getBytes());
        }
        
        // Create the digest from the message
        return new String(Hex.encodeHex(md.digest()));
    }
}
