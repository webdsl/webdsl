package utils;

import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.*;
import javax.servlet.http.*;

import utils.*;

public class DispatchServlet extends HttpServlet {

    static{
        application.InitTemplates.initTemplates();
        application.Init.init();
    }
    
    private void addToValues(String key, String val, HashMap<String, java.util.ArrayList<String>> parammapvalues){
      List<String> current = parammapvalues.get(key); 
      if(current==null){
        ArrayList<String> newlist = new ArrayList<String>();
        newlist.add(val);
        parammapvalues.put(key,newlist) ; 
      }
      else{
       current.add(val);
      }
    }
      
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
      boolean showerrorpage = false;
      try{
        String[] req = request.getRequestURL().toString().split("/");
        int count;
        for(count=0;count<req.length;count++)
        {
          if(req[count].equals(AppInfo.getAppName()))
          {
            count++;
            break;
          }
        }
        String requested = req[count];
        String[] args = java.util.Arrays.copyOfRange(req, count+1, req.length);
        String[] argnames = application.Pagearguments.pagearguments.get(requested);

        java.util.HashMap<String, utils.File> fileUploads = new HashMap<String, utils.File>();
        java.util.HashMap<String, String> parammap = new HashMap<String, String>();
        java.util.HashMap<String, java.util.ArrayList<String>> parammapvalues = new HashMap<String, java.util.ArrayList<String>>();

        for(java.util.Enumeration en = request.getParameterNames();en.hasMoreElements(); ){
          String parameterName = (String)en.nextElement();
          parammap.put(parameterName,request.getParameter(parameterName)); 
          for(String paramval : request.getParameterValues(parameterName)){
            addToValues(parameterName, paramval, parammapvalues);
          } 
        }

        for(int count2=0; count2<args.length;count2++)
        {
          parammap.put(argnames[count2],args[count2]);
          addToValues(argnames[count2],args[count2],parammapvalues);
        }
        
        //http://commons.apache.org/fileupload/using.html
        // Check that we have a file upload request
        boolean isMultipart = org.apache.commons.fileupload.servlet.ServletFileUpload.isMultipartContent(request);
        if(isMultipart){
            
            // Create a factory for disk-based file items
            org.apache.commons.fileupload.FileItemFactory factory = new org.apache.commons.fileupload.disk.DiskFileItemFactory();
    
            // Set factory constraints
            //factory.setSizeThreshold(yourMaxMemorySize);//make configurable
            //factory.setRepository(yourTempDirectory);//make configurable
            
            // Create a new file upload handler
            org.apache.commons.fileupload.servlet.ServletFileUpload upload = new org.apache.commons.fileupload.servlet.ServletFileUpload(factory);
    
            // Set overall request size constraint
            //upload.setSizeMax(); //make configurable
            
            // Parse the request
            try {
                java.util.List<org.apache.commons.fileupload.FileItem> items = (java.util.List<org.apache.commons.fileupload.FileItem>) upload.parseRequest(request);
            
                // Process the uploaded items
                java.util.Iterator<org.apache.commons.fileupload.FileItem> iter = items.iterator();
                while (iter.hasNext()) {
                    org.apache.commons.fileupload.FileItem item = (org.apache.commons.fileupload.FileItem) iter.next();
    
                    if (item.isFormField()) {
                        String name = item.getFieldName();
                        String value = item.getString();
                        parammap.put(name, value);
                        addToValues(name, value, parammapvalues);
                    } else {
                        String fieldName = item.getFieldName();
                        String fileName = item.getName();
                        String contentType = item.getContentType();
                        boolean isInMemory = item.isInMemory();
                        long sizeInBytes = item.getSize();
                        utils.File temp = new utils.File();
                        temp.setFileName(fileName);
                        temp.setContentType(contentType);
                        temp.setSizeInBytes(sizeInBytes);
                     
                        temp.setContentStream(item.getInputStream());
    
                        fileUploads.put(fieldName, temp);
                    }
                }
            
            } catch (org.apache.commons.fileupload.FileUploadException ex) {
                System.out.println("exception occured in file upload handling DispatchServlet");
                ex.printStackTrace();
            }
        }
        
        
        pil.reflect.Class pc = application.Pages.pages.get(requested);
       
        if(pc != null)
        {
            try{
                PageServlet pageservlet = (PageServlet)pc.newInstance();
      
                webdsl.Session s = new webdsl.Session(new java.util.HashMap<String, Object>());
                for (java.util.Enumeration e = request.getSession().getAttributeNames() ; e.hasMoreElements() ;) {
                    String k = (String)e.nextElement();
                    s.set(k, request.getSession().getAttribute(k));
                }
                webdsl.Request r = new webdsl.Request(s, new java.util.HashMap<String, String>(request.getParameterMap()));
                webdsl.util.StringWriter wr = new webdsl.util.StringWriter();
                webdsl.Response res = new webdsl.Response(wr);
                //pageservlet.serve(r,res,parammap,parammapvalues,fileUploads);
                pageservlet.serve(r,res,parammap,parammapvalues,null);
                for(Object key : res.getHeaders().keySet()) {
                    if(key.equals("Location")) {
                        response.sendRedirect(res.getHeaders().get(key));
                    } else {
                        response.addHeader(key.toString(), res.getHeaders().get(key).toString());
                    }
                }
                response.getWriter().write(res.getWriter().toString());

            }
            /*catch(IllegalAccessException iae){
                System.out.println("Problem in dispatch servlet page lookup: "+iae.getMessage());
                iae.printStackTrace();
                showerrorpage=true;
            }
            catch(InstantiationException ie){
                System.out.println("Problem in dispatch servlet page lookup: "+ie.getMessage());
                ie.printStackTrace();
                showerrorpage=true;
            }*/
            catch(RuntimeException re){   
              showerrorpage=true;
            }	  
        }
        else{showerrorpage=true;}
      }
      catch(Exception ex){
        System.out.println("Exception in dispatch servlet: "+ex.getMessage());
        ex.printStackTrace();
        showerrorpage=true;
      }
      
      if(showerrorpage)
      {
          response.sendError(javax.servlet.http.HttpServletResponse.SC_NOT_FOUND);
      }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws IOException, ServletException
    {
        doGet(request, response);
    }
}
