package utils;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;

import org.webdsl.logging.Logger;

import com.google.common.hash.Hashing;
import com.google.common.io.Files;

public class CachedResourceFileNameHelper {
  private static Map<String, String> resources = new HashMap<>();
  private static String resourcePathRoot = null;
  private static boolean warningShown = false;
  public static void init( ServletContext ctx ){
    resourcePathRoot = ctx.getRealPath( File.separator );
  }
    
  //Given a name of a resource (with or without existing query param), it returns the name with the file hash (md5) as query param
  //This way, the browser will never use its client-cached resource when the resource changed. This method caches the hashed filenames, so
  //they will only be read from disk once during the life cycle of the application servlet.
  public static String getNameWithHash(String resourceDirName, String name){
    String hashname = resources.get( name );
    if( hashname == null){
      if( resourcePathRoot == null ){
        if(!warningShown){
          Logger.warn( CachedResourceFileNameHelper.class.getName() + " is not initialized by the servlet context or the servlet is not deployed in an exploded way (e.g. when serving directly from war-file). It won't add file-hashes to resource file names." );
          warningShown = true;
        }
        hashname = name;
      } else {
        String nameNoSuffix = name.replaceAll("(\\?.*)$", "");
        String realPath = resourcePathRoot + "/" + resourceDirName + "/" + nameNoSuffix;
        try {
          String hashStr = Files.asByteSource( new File(realPath)).hash(Hashing.md5()).toString();
          hashname = nameNoSuffix + "?" + hashStr;
        } catch (IOException e) {
          Logger.error(e);
          hashname = name;
        }        
        resources.put(name, hashname);
      }
    }
    return hashname;  
  }
}
