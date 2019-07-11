package utils;

import java.net.URLConnection;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.webdsl.logging.Logger;

import utils.File;

public class URLType {
    
	
	/*	
		tests: @ https://regex101.com/r/pH6cY5/1
		inspired by https://mathiasbynens.be/demo/url-regex and the pattern from @imme_emosol
		
		Accepts any protocol (required)
	*/
    public static Boolean isValid(String s){
      if(s != null && s.equals("") || s.matches("^(([a-zA-Z]+:\\/\\/)|mailto:)(-\\.)?([^\\s\\/?\\.#\\-](-*[^\\s\\/?\\.#\\-])*\\.?)+(\\/[^\\s]*)?$")) {
        return true;
      }
      return false;
    }
    
	private static SSLSocketFactory sslSocketFactory = null;
	
	/* 
	 * Downloads the content residing on the given url (typically a downloadable file)
	 * into a File that is returned.
	 * NOTE: THIS DOWNLOAD METHOD HAS NO CERTIFICATE REVOCATION CHECK 
	 */
	public static File download(String urlStr){
		utils.File f = null;
		try {
			java.net.URL url = new java.net.URL(urlStr);
			URLConnection con = url.openConnection();
			if(con instanceof HttpsURLConnection){
				setAcceptAllVerifier((HttpsURLConnection) con);
			}
			f = new File();
			f.setContentStream(con.getInputStream());
			String raw = con.getHeaderField("Content-Disposition");
			// raw = "attachment; filename=abc.jpg"
			String fileName = "";
			String[] parts = con.getContentType().split(";");
			if(parts.length > 0){
				f.setContentType(parts[0]);
			}
			if(raw != null && raw.indexOf("=") != -1) {
			    fileName = raw.split("=")[1]; //getting value after '='
			} else {
				String ext = "";
				if(f.getContentType() !=  null){
					String ext_ = File.mimeTypeToExt(parts[0]);
					if(ext_ != null){
						ext = "." + ext_ ;
					}					
				}
				fileName = "noname" + ext;  
			}
			f.setFileName(fileName);
		} catch (Exception e) {
			Logger.error(e);
		}
		return f;
	}
	
    protected static void setAcceptAllVerifier(HttpsURLConnection connection) throws NoSuchAlgorithmException, KeyManagementException {

        // Create the socket factory.
        // Reusing the same socket factory allows sockets to be
        // reused, supporting persistent connections.
        if( null == sslSocketFactory) {
            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, ALL_TRUSTING_TRUST_MANAGER, new java.security.SecureRandom());
            sslSocketFactory = sc.getSocketFactory();
        }

        connection.setSSLSocketFactory(sslSocketFactory);

        // Since we may be using a cert with a different name, we need to ignore
        // the hostname as well.
        connection.setHostnameVerifier(ALL_TRUSTING_HOSTNAME_VERIFIER);
    }

    private static final TrustManager[] ALL_TRUSTING_TRUST_MANAGER = new TrustManager[] {
        new X509TrustManager() {
            public X509Certificate[] getAcceptedIssuers() {
                return null;
            }
            public void checkClientTrusted(X509Certificate[] certs, String authType) {}
            public void checkServerTrusted(X509Certificate[] certs, String authType) {}
        }
    };

    private static final HostnameVerifier ALL_TRUSTING_HOSTNAME_VERIFIER  = new HostnameVerifier() {
        public boolean verify(String hostname, SSLSession session) {
            return true;
        }
    };
}
