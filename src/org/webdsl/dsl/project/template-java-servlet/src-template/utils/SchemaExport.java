package utils;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import org.hibernate.*;

import java.util.*;

@SuppressWarnings("unused")
public class SchemaExport {

    static Session hibSession;
    
    public static void main(String[] args) {


        //hibSession = HibernateUtilConfigured.getSessionFactory().getCurrentSession();
        //hibSession.beginTransaction();
        
        try
        { 
            org.hibernate.tool.hbm2ddl.SchemaExport export = new org.hibernate.tool.hbm2ddl.SchemaExport(HibernateUtilConfigured.getAnnotationConfiguration());//, hibSession.connection());
            export.setOutputFile("schema-export.sql");
            export.create(true,false);
            
            
        //	hibSession.flush();
        //	hibSession.getTransaction().commit();
    
        }
        catch(Exception ex)
        { 
            handleException(ex);
        }

    }

    public static void handleException(Exception ex){
        System.out.println("exception occured: " + ex.getMessage());
        ex.printStackTrace();
        hibSession.getTransaction().rollback();
        throw new RuntimeException("conversion failed!");
    }

}
