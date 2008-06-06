package org.webdsl.tools;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
        } else if(a == null || b == null) {
            return false;
        }
        return a.equals(b);
    }

    public static boolean isInstance(Object o, Class<?> c) {
        if(o instanceof WebDSLEntity) {
            return ((WebDSLEntity)o).isInstance(c);
        } else {
            return c.isInstance(o);
        }
    }

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