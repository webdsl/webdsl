package org.webdsl.tools;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.faces.context.FacesContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.webdsl.WebDSLEntity;

public final class Utils {
    public static Date parseDate(String date, String format) {
        try {
            return new SimpleDateFormat(format).parse(date);
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
    }

    /*public static boolean equal(int a, int b) {
        return a == b;
    }

    public static boolean equal(double a, double b) {
        return a == b;
    }

    public static boolean equal(int a, Integer b) {
        return b.equals(a);
    }

    public static boolean equal(double a, Double b) {
        return b.equals(a);
    }*/

    public static boolean equal(Object a, Object b) {
        if(a == null && b == null) {
            return true;
        } else if( (a == null && b != null) || (a != null && b == null) ) {
            return false;
        }
        return a.equals(b);
    }
    
    public static Object cast(Object e2 , Class<?> t) {
        return (e2 instanceof org.hibernate.proxy.HibernateProxy)? 
            t.cast( ((org.hibernate.proxy.HibernateProxy) e2).getHibernateLazyInitializer().getImplementation()) 
          : t.cast(e2);
    }

    public static boolean isInstance(Object o, Class<?> c) {
        //org.hibernate.Hibernate.initialize(o);
        if(o instanceof WebDSLEntity) {
            return ((WebDSLEntity)o).isInstance(c);
        } else {
            return c.isInstance(o);
        }
    }
    
    public static String encodeIdList(Object o){
        List<WebDSLEntity> l = (List<WebDSLEntity>) o;
        String res = "";
        for(WebDSLEntity obj: l) {
            res+=obj.getId()+",";
        }        
        return res.substring(0, Math.max(0,res.length()-1));
    }
    
    /**
     * http://forum.hibernate.org/viewtopic.php?p=2387828
     * 
     * Utility method that tries to properly initialize the Hibernate CGLIB
     * proxy.
     *
     * @param <T>
     * @param maybeProxy -- the possible Hibernate generated proxy
     * @param baseClass -- the resulting class to be cast to.
     * @return the object of a class <T>
     * @throws ClassCastException
     */
    /*public <T> T deproxy(Object maybeProxy, Class<T> baseClass) throws ClassCastException {
       if (maybeProxy instanceof org.hibernate.proxy.HibernateProxy) {
          return baseClass.cast(((org.hibernate.proxy.HibernateProxy) maybeProxy).getHibernateLazyInitializer().getImplementation());
       }
       return baseClass.cast(maybeProxy);
    } */

    public static void download(FacesContext facesContext, byte[] file, String name, String type) {
        if (!facesContext.getResponseComplete()) {
            HttpServletResponse response = (HttpServletResponse) facesContext.getExternalContext().getResponse();
            response.setContentType(type);
            response.setContentLength(file.length);
            response.setHeader("Content-disposition","attachment; filename=" + name);
            ServletOutputStream out;
            try {
                out = response.getOutputStream();
                out.write(file);
                out.flush();
            } catch (IOException e) {
                //TODO: something
            }
            facesContext.responseComplete();
        }
    }
}