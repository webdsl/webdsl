package utils;

import java.io.ByteArrayInputStream;

import org.hibernate.Session;

public class ImageSizeUtils {

  private final static double JPG_QUALITY = 0.85;

  public static void resizeImage(Session session, utils.File file, int width,
      int height) {
    try {
      // session.refresh(file);
      javaxt.io.Image img = new javaxt.io.Image(file.getContentStream());
      if (width == 0) {
        width = img.getWidth();
      }
      if (height == 0) {
        height = img.getHeight();
      }
      if (width > img.getWidth()) {
        width = img.getWidth();
      }
      if (height > img.getHeight()) {
        height = img.getHeight();
      }
      int newWidth;
      int newHeight;
      if ((float) height / (float) img.getHeight() > (float) width
          / (float) img.getWidth()) {
        float factor = (float) width / (float) img.getWidth();
        newWidth = (int) (Math.round(factor * (float) img.getWidth()));
        newHeight = (int) (Math.round(factor * (float) img.getHeight()));
      } else {
        float factor = (float) height / (float) img.getHeight();
        newWidth = (int) (Math.round(factor * (float) img.getWidth()));
        newHeight = (int) (Math.round(factor * (float) img.getHeight()));
      }

      img.resize(newWidth, newHeight, true);
      img.sharpen();
      img.setOutputQuality(JPG_QUALITY);
      writeImageToFile(img, file);
      session.flush();
    } catch (Exception e) {
      org.webdsl.logging.Logger.error("EXCEPTION", e);
    }
  }

  private static void writeImageToFile(javaxt.io.Image img, utils.File file) {
    javaxt.io.File xtFile = new javaxt.io.File(file.getFileName());
    String extension = xtFile.getExtension();
    try {
      if (extension != "") {
        file.setContentStream(new ByteArrayInputStream(img
            .getByteArray(extension)));
        file.setContentType(xtFile.getContentType());
      } else {
        file.setContentStream(new ByteArrayInputStream(img
            .getByteArray()));
        file.setContentType("image/jpeg");
      }
    } catch (Exception e) {
      org.webdsl.logging.Logger.error("EXCEPTION", e);
    }
  }

  public static void cropImage(Session session, utils.File file, int x,
      int y, int width, int height) {
    try {
      // session.refresh(file);
      javaxt.io.Image img = new javaxt.io.Image(file.getContentStream());
      img.crop(x, y, width, height);
      img.setOutputQuality(90);
      writeImageToFile(img, file);
      session.flush();
    } catch (Exception e) {
      org.webdsl.logging.Logger.error("EXCEPTION", e);
    }
  }

  public static int getWidth(Session session, utils.File file) {
    try {
      // session.refresh(file);
      javaxt.io.Image img = new javaxt.io.Image(file.getContentStream());
      return img.getWidth();
    } catch (Exception e) {
      org.webdsl.logging.Logger.error("EXCEPTION", e);
      return 0;
    }
  }

  // private static List<Class<?>> loadedPluginClasses = new
  // ArrayList<Class<?>>();
  // public static void unloadPlugins(){
  // IIORegistry registry = IIORegistry.getDefaultInstance();
  // for (Class<?> cl : loadedPluginClasses) {
  // Object spi = registry.getServiceProviderByClass(cl);
  // if (spi != null) {
  // registry.deregisterServiceProvider(spi);
  // }
  // }
  // }
  // static{
  // ImageIO.scanForPlugins();
  // String names[] = ImageIO.getReaderFormatNames();
  // for (String name : names) {
  // Iterator<ImageReader> readers = ImageIO.
  // getImageReadersByFormatName(name);
  // while (readers.hasNext()) {
  // ImageReader reader = readers.next();
  // if(reader.getClass().getPackage().getName().startsWith("com.twelvemonkeys.imageio.plugins")){
  // loadedPluginClasses.add(reader.getClass());
  // }
  // System.out.println("***************************** reader: " + reader);
  // }
  // }
  //
  //
  // names = ImageIO.getWriterFormatNames();
  // for (String name : names) {
  // Iterator<ImageWriter> writers = ImageIO.
  // getImageWritersByFormatName(name);
  // while (writers.hasNext()) {
  // ImageWriter writer = writers.next();
  // if(writer.getClass().getPackage().getName().startsWith("com.twelvemonkeys.imageio.plugins")){
  // loadedPluginClasses.add(writer.getClass());
  // }
  // System.out.println("***************************** writer: " + writer);
  // }
  // }
  //

  // }

  public static int getHeight(Session session, utils.File file) {
    try {
      javaxt.io.Image img = new javaxt.io.Image(file.getContentStream());
      // session.refresh(file);
      return img.getHeight();
    } catch (Exception e) {
      org.webdsl.logging.Logger.error("EXCEPTION", e);
      return 0;
    }
  }
}
