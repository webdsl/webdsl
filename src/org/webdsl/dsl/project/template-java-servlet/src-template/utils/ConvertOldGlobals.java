package utils;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;

import org.hibernate.*;
import java.util.*;

@SuppressWarnings({"deprecation","unused"})
public class ConvertOldGlobals {

    static Session hibSession;

    public static void emptySessionObjects(){
        try{ 
            System.out.println("emptying session objects");
            PreparedStatement del = hibSession.connection().prepareStatement(
                    "delete FROM _SecurityContext"
            );
            del.executeUpdate();
            System.out.println("done emptying session objects");
        }
        catch(Exception ex){
            handleException(ex);
        }
    }
    
    public static void convertGlobals(){
        System.out.println("converting globals");
        try
        { 
            SQLQuery q = hibSession.createSQLQuery("select databaseId from ApplicationContextProperty order by id asc"); 	
            for(Object o : q.list()){

                if(o != null){ //__global__init__ has databaseId null
                    UUID temp = UUID.fromString(o.toString());

                    PreparedStatement updateIds = hibSession.connection().prepareStatement(
                            "UPDATE ApplicationContextProperty SET databaseId = ? WHERE databaseId = ?"
                    );

                    updateIds.setString(1, persistUUIDString(temp));
                    updateIds.setString(2, temp.toString());

                    updateIds.executeUpdate();

                }
            }
        }
        catch(Exception ex){
            handleException(ex);
        }
        System.out.println("done converting globals");
    }

    public static String persistUUIDString(UUID uuid){
        StringBuffer sb = new StringBuffer(uuid.toString());
        //remove hyphens
        sb.deleteCharAt(23);
        sb.deleteCharAt(18);
        sb.deleteCharAt(13);
        sb.deleteCharAt(8);
        return sb.toString();
    }

    public static void convertId(String table, String column){
        System.out.println("altering column "+table+"."+column);
        try
        { 
            PreparedStatement alterTable1 = hibSession.connection().prepareStatement(
                    "ALTER TABLE "+table+" ADD COLUMN "+column+"TEMPORARY234987 VARCHAR(32)");	
            alterTable1.executeUpdate();

            System.out.println("done altering column "+table+"."+column);
            System.out.println("altering column data "+table+"."+column);
            
            boolean itemProcessed;
            do {
                java.sql.Statement stmt = hibSession.connection().createStatement(java.sql.ResultSet.TYPE_SCROLL_SENSITIVE,java.sql.ResultSet.CONCUR_READ_ONLY);			
                java.sql.ResultSet srs = stmt.executeQuery("select "+column+" from "+table+" WHERE "+column+"TEMPORARY234987 IS NULL AND "+column+" IS NOT NULL LIMIT 50000" );
                
                itemProcessed = false;
                while(srs.next()){
                    byte[] value = srs.getBytes(1);
                    if(value != null && value.length > 0){
                        java.io.DataInputStream dis = new java.io.DataInputStream(new java.io.ByteArrayInputStream(value));
                        long most=(Long)dis.readLong();
                        long least=(Long)dis.readLong();
                        UUID temp = new UUID(most,least);

                        PreparedStatement updateIds = hibSession.connection().prepareStatement("UPDATE "+table+" SET "+column+"TEMPORARY234987 = ? WHERE "+column+" = ?");

                        updateIds.setString(1, persistUUIDString(temp));
                        updateIds.setBytes(2, value);

                        updateIds.executeUpdate();
                        updateIds.close();
                    }
                    itemProcessed = true;
                }
                srs.close();
                stmt.close();
                
                java.sql.Statement stmt2 = hibSession.connection().createStatement(java.sql.ResultSet.TYPE_SCROLL_SENSITIVE,java.sql.ResultSet.CONCUR_READ_ONLY);			
                java.sql.ResultSet srs2 = stmt2.executeQuery("SELECT count(*) FROM "+table+" WHERE "+column+"TEMPORARY234987 IS NULL" );
                srs2.next();
                System.out.println("Items to proccess in this column: " + srs2.getLong(1));
                srs2.close();
                stmt2.close();
            } while(itemProcessed);
                 
                 PreparedStatement alterTable2 = hibSession.connection().prepareStatement(
               "ALTER TABLE "+table+" MODIFY COLUMN "+column+" VARCHAR(32)");
            alterTable2.executeUpdate();
            
            PreparedStatement update1 = hibSession.connection().prepareStatement(
               "UPDATE "+table+" SET "+column+"="+column+"TEMPORARY234987");
              update1.executeUpdate();
              
              PreparedStatement alterTable3 = hibSession.connection().prepareStatement(
               "ALTER TABLE "+table+" DROP "+column+"TEMPORARY234987");
              alterTable3.executeUpdate();


            System.out.println("done altering column data "+table+"."+column);
        }
        catch(Exception ex){
            handleException(ex);
        }
    }
    
    public static List<String> convertedTables = new LinkedList<String>();
    
    public static void convertCharSet(String table, String column, String type){
        System.out.println("altering charset "+table+"."+column);
        String typenew = type;
        //type from dump was not converted yet
        if(type.equals("varchar(16)")){
            typenew = "varchar(32)";
        }
        try
        { 
            PreparedStatement alterTable = hibSession.connection().prepareStatement(
                "ALTER TABLE "+table+" MODIFY COLUMN "+column+" "+typenew+" CHARACTER SET utf8 COLLATE utf8_general_ci"
            );	
            alterTable.executeUpdate();
            
            System.out.println("done altering charset "+table+"."+column);
            
            if(!convertedTables.contains(table)){
                System.out.println("altering table default charset "+table);
                
                convertedTables.add(table);
                PreparedStatement alterTableDef = hibSession.connection().prepareStatement(
                        "ALTER TABLE "+table+" CHARACTER SET utf8"
                );	
                alterTableDef.executeUpdate();
                System.out.println("done altering table default charset "+table);
                
            }
        }
        catch(Exception ex){
            handleException(ex);
        }
    }


    public static void main(String[] args) {


        hibSession = HibernateUtilConfigured.getSessionFactory().getCurrentSession();
        hibSession.beginTransaction();
//		hibSession.setFlushMode(org.hibernate.FlushMode.MANUAL);
        emptySessionObjects();
        convertGlobals();
        
        try
        { 
            java.io.BufferedReader br = new java.io.BufferedReader(new java.io.FileReader("mysqloutput.tmp"));
            br.readLine();
            String line;
            while((line = br.readLine()) != null){
                String[] tablecolumn = line.split("\t");
                String table = tablecolumn[0];
                String column = tablecolumn[1];

                convertId(table,column);
            }
            
            br = new java.io.BufferedReader(new java.io.FileReader("mysqloutput2.tmp"));
            br.readLine();
            while((line = br.readLine()) != null){
                String[] tablecolumn = line.split("\t");
                String table = tablecolumn[0];
                String column = tablecolumn[1];
                String type = tablecolumn[2];
                
                convertCharSet(table,column, type);
            }

            hibSession.flush();
            hibSession.getTransaction().commit();
            System.out.println("conversion done!");
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
