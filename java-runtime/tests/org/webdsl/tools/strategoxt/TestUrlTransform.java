package org.webdsl.tools.strategoxt;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import utils.AbstractDispatchServletHelper;
import utils.PageDispatch;
import utils.ThreadLocalServlet;
import junit.framework.TestCase;

public class TestUrlTransform extends TestCase {

    public void testHttpsConvert() throws Exception {

        ThreadLocalServlet.set(new AbstractDispatchServletHelper() {
            @Override
            public String getRequestedPage() {
                return null;
            }
            @Override
            public HttpServletRequest getRequest() {
                return null;
            }
            @Override
            public HashMap<String, PageDispatch> getPages() {
                return null;
            }
            @Override
            public String getContextPath() {
                return null;
            }
            @Override
            public int getHttpsPort() {
                return 8443;
            }
            @Override
            public int getHttpPort() {
                return 8080;
            }
        });
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost:8080/foo").equals("https://localhost:8443/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost:80/foo").equals("https://localhost:8443/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost/foo").equals("https://localhost:8443/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost:8080/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("https://localhost:8443/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("https://localhost:8443/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://webdsl.org:80/foo").equals("https://webdsl.org:8443/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("https://webdsl.org:8443/foo").equals("https://webdsl.org:8443/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("https://webdsl.org/foo").equals("https://webdsl.org:8443/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://webdsl.org:80/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("https://webdsl.org:8443/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://webdsl.org/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("https://webdsl.org:8443/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
    
        ThreadLocalServlet.set(new AbstractDispatchServletHelper() {
            @Override
            public String getRequestedPage() {
                return null;
            }
            @Override
            public HttpServletRequest getRequest() {
                return null;
            }
            @Override
            public HashMap<String, PageDispatch> getPages() {
                return null;
            }
            @Override
            public String getContextPath() {
                return null;
            }
            @Override
            public int getHttpsPort() {
                return 443;
            }
            @Override
            public int getHttpPort() {
                return 8080;
            }
        });
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost:8080/foo").equals("https://localhost/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost:80/foo").equals("https://localhost/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost/foo").equals("https://localhost/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost:8080/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("https://localhost/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://localhost/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("https://localhost/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://webdsl.org:80/foo").equals("https://webdsl.org/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("https://webdsl.org:8443/foo").equals("https://webdsl.org/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("https://webdsl.org/foo").equals("https://webdsl.org/foo"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://webdsl.org:80/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("https://webdsl.org/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpsUrl("http://webdsl.org/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("https://webdsl.org/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        
    
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost:8443/foo").equals("http://localhost:8080/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost:443/foo").equals("http://localhost:8080/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost/foo").equals("http://localhost:8080/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost:8443/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("http://localhost:8080/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("http://localhost:8080/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://webdsl.org:443/foo").equals("http://webdsl.org:8080/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("http://webdsl.org:80/foo").equals("http://webdsl.org:8080/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("http://webdsl.org/foo").equals("http://webdsl.org:8080/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://webdsl.org:443/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("http://webdsl.org:8080/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://webdsl.org/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("http://webdsl.org:8080/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        
        ThreadLocalServlet.set(new AbstractDispatchServletHelper() {
            @Override
            public String getRequestedPage() {
                return null;
            }
            @Override
            public HttpServletRequest getRequest() {
                return null;
            }
            @Override
            public HashMap<String, PageDispatch> getPages() {
                return null;
            }
            @Override
            public String getContextPath() {
                return null;
            }
            @Override
            public int getHttpsPort() {
                return 443;
            }
            @Override
            public int getHttpPort() {
                return 80;
            }
        });
        
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost:8443/foo").equals("http://localhost/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost:443/foo").equals("http://localhost/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost/foo").equals("http://localhost/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost:8443/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("http://localhost/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://localhost/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("http://localhost/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://webdsl.org:443/foo").equals("http://webdsl.org/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("http://webdsl.org:80/foo").equals("http://webdsl.org/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("http://webdsl.org/foo").equals("http://webdsl.org/foo"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://webdsl.org:443/foo/gffgh/fghfhgf/gffhhf/fghgff").equals("http://webdsl.org/foo/gffgh/fghfhgf/gffhhf/fghgff"));
        assertTrue(utils.UrlTransform.convertToHttpUrl("https://webdsl.org/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg").equals("http://webdsl.org/foo/dfdgfdg/dgfddf/gdgdgfd/fdgdfg"));
        
    }

}
