package utils;

import java.io.File;
import java.io.IOException;
import java.nio.file.ClosedWatchServiceException;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.WatchKey;
import java.nio.file.WatchService;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.HashMap;
import java.util.Map;
import static java.nio.file.StandardWatchEventKinds.*;
import java.nio.file.WatchEvent;

import javax.servlet.ServletContext;

import org.webdsl.logging.Logger;

import com.google.common.hash.Hashing;
import com.google.common.io.Files;

public class CachedResourceFileNameHelper {
  private static Map<String, String> resources = new HashMap<>();
  private static String resourcePathRoot = null;
  private static boolean warningShown = false;

  public static void init(ServletContext ctx) {
    resourcePathRoot = ctx.getRealPath(File.separator);
    setCommonAndFavIcoTagSuffixes();
    invalidateOnChanges(resourcePathRoot);
  }

  // Given a name of a resource (with or without existing query param), it
  // returns the name with the file hash (md5) as query param
  // This way, the browser will never use its client-cached resource when the
  // resource changed. This method caches the hashed filenames
  // until a change is detected in the file resources (using a directory
  // watcher)
  public static String getNameWithHash(String resourceDirName, String name) {
    String hashname = resources.get(name);
    if (hashname == null) {
      if (resourcePathRoot == null) {
        if (!warningShown) {
          Logger.warn(CachedResourceFileNameHelper.class.getName()
              + " is not initialized by the servlet context or the servlet is not deployed in an exploded way (e.g. when serving directly from war-file). It won't add file-hashes to resource file names.");
          warningShown = true;
        }
        hashname = name;
      } else {
        String nameNoSuffix = name.replaceAll("(\\?.*)$", "");
        String realPath = resourcePathRoot + File.separator + resourceDirName + File.separator + nameNoSuffix;
        try {
          String hashStr = Files.asByteSource(new File(realPath)).hash(Hashing.md5()).toString();
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

  public static void invalidateCache() {
    resources.clear();
    setCommonAndFavIcoTagSuffixes();
    if (AbstractPageServlet.pageCacheEnabled) {
      AbstractPageServlet.doInvalidateAllPageCache("change in css or js resource");
    }
  }

  public static String common_css_link_tag_suffix;
  public static String fav_ico_link_tag_suffix;

  private static void setCommonAndFavIcoTagSuffixes() {
    common_css_link_tag_suffix = "/stylesheets/"
        + CachedResourceFileNameHelper.getNameWithHash("stylesheets", "common_.css")
        + "\" rel=\"stylesheet\" type=\"text/css\" />";
    fav_ico_link_tag_suffix = "/" + CachedResourceFileNameHelper.getNameWithHash("", "favicon.ico")
        + "\" rel=\"shortcut icon\" type=\"image/x-icon\" />";
  }

  /* Watch for changes */

  private static WatchService watcher;
  private static Thread dirWatcherThread;

  public static void invalidateOnChanges(String resourcePathRoot) {
    
    if(resourcePathRoot == null || ! (new File(resourcePathRoot).exists()) ) {
      //don't start watcher when path root is empty or does not exists
      return;
    }
    
    String jsDir = resourcePathRoot + File.separator + "javascript";
    String cssDir = resourcePathRoot + File.separator + "stylesheets";
    Path jsPath = Paths.get(jsDir);
    Path cssPath = Paths.get(cssDir);
    Path[] paths = { jsPath, cssPath };

    try {
      watcher = FileSystems.getDefault().newWatchService();

      for (Path path : paths) {
        java.nio.file.Files.walkFileTree(path, new java.nio.file.SimpleFileVisitor<Path>() {
          @Override
          public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException {
            dir.register(watcher, ENTRY_CREATE, ENTRY_MODIFY);
            return FileVisitResult.CONTINUE;
          }
        });
      }
    } catch (IOException e) {
      Logger.error(
          "Error during initialization of directory watcher for cache busting css/js resources on change. Changes won't be detected",
          e);
      return;
    }

    dirWatcherThread = new Thread() {
      public void run() {

        while (!this.isInterrupted()) {
          WatchKey key;
          try {
            // wait for a key to be available
            key = watcher.take();
          } catch (InterruptedException | ClosedWatchServiceException ex) {
            return;
          }

          for (WatchEvent<?> event : key.pollEvents()) {
            WatchEvent.Kind<?> kind = event.kind();
            if (kind == OVERFLOW) {
              continue;
            } else {
              @SuppressWarnings("unchecked")
              WatchEvent<Path> ev = (WatchEvent<Path>) event;
              Path changedFile = ev.context();
              Logger.info("Change to resource file '" + changedFile
                  + "' detected, going to recalculate file hashes for js/css includes.");

              invalidateCache();
            }
          }
          boolean valid = key.reset();
          if (!valid) {
            break;
          }
        }

      }
    };
    dirWatcherThread.setDaemon(true);
    dirWatcherThread.setName("Watcher thread for changes in js/css resources");
    dirWatcherThread.start();
  }
  
  public static void cleanupOnServletDestroy() {
    if(watcher == null) {
      return;
    }
    try {
      watcher.close();
    } catch (IOException e) {
      Logger.error(e);
    }
//    dirWatcherThread.interrupt();
  }

}
