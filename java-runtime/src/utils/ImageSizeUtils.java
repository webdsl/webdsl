package utils;

import openize.heic.decoder.HeicImage;
import openize.heic.decoder.PixelFormat;
import openize.io.IOFileStream;
import openize.io.IOMode;

import com.google.common.cache.Cache;
import com.google.common.cache.CacheBuilder;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.Iterator;

public class ImageSizeUtils {

  private static final double JPG_QUALITY = 0.85;
  private static final float WEBP_QUALITY = 0.84f;

  // --- Single cache: weak keys ensure GC when File is no longer referenced ---

  private static final Cache<utils.File, ImageMetadata> metadataCache = CacheBuilder.newBuilder().weakKeys().build();

  private static final class ImageMetadata {
    final String contentType;
    final int width, height;
    final javaxt.io.Image image;

    ImageMetadata(String contentType, javaxt.io.Image image) {
      this.contentType = contentType;
      this.image  = image;
      this.width  = (image != null && image.getBufferedImage() != null) ? image.getWidth()  : 0;
      this.height = (image != null && image.getBufferedImage() != null) ? image.getHeight() : 0;
    }
  }

  // --- Cache management ---

  public static void invalidateCache(utils.File file) {
    metadataCache.invalidate(file);
  }

  private static ImageMetadata getMetadata(utils.File file) {
    try {
      return metadataCache.get(file, () -> {
        String ct = detectRealContentType(file);
        if (ct.startsWith("image/heic") || ct.startsWith("image/heif")) {
          // Convert inline without touching the cache or calling convertToFormat
          byte[] src = readAllBytes(file.getContentStream());
          byte[] jpg = convertHeicToFormat(src, "jpg");
          file.setContentStream(new ByteArrayInputStream(jpg));
          file.setContentType("image/jpeg");
          updateFileNameExtension(file, "jpg");
          ct = "image/jpeg";
        }
        return new ImageMetadata(ct, loadJavaxtImage(file));
      });
    } catch (Exception e) {
      logExceptionWithFileInfo(e, file);
      return new ImageMetadata("application/octet-stream", null);
    }
  }

  // Raw load only — no HEIC check, no cache interactions, no loops possible
  private static javaxt.io.Image loadJavaxtImage(utils.File file) throws IOException {
    try {
      return new javaxt.io.Image(file.getContentStream());
    } catch (SQLException e) {
      throw new IOException("Failed to open content stream", e);
    }
  }

  private static javaxt.io.Image getOrCreateJavaxtImage(utils.File file) throws IOException {
    javaxt.io.Image img = getMetadata(file).image;
    if (img == null) throw new IOException("Failed to load image for file: " + file.getFileName());
    return img;
  }

  // --- Public accessors ---

  public static String getRealContentType(utils.File file) { return getMetadata(file).contentType; }
  public static int    getWidth(utils.File file)           { return getMetadata(file).width; }
  public static int    getHeight(utils.File file)          { return getMetadata(file).height; }

  public static javaxt.io.Image createJavaxtImageFromFile(utils.File file) throws IOException {
    if (file == null) return null;
    return getOrCreateJavaxtImage(file);
  }

  // --- Mutating operations ---

  public static void resizeImage(utils.File file, int width, int height) {
    try {
      javaxt.io.Image img = getOrCreateJavaxtImage(file);

      if (width  == 0 || width  > img.getWidth())  width  = img.getWidth();
      if (height == 0 || height > img.getHeight()) height = img.getHeight();

      float factor = ((float) height / img.getHeight() > (float) width / img.getWidth())
          ? (float) width  / img.getWidth()
          : (float) height / img.getHeight();

      img.resize(Math.round(factor * img.getWidth()), Math.round(factor * img.getHeight()), true);

      if (img.getWidth() > 2 && img.getHeight() > 2) {
        try { img.sharpen(); }
        catch (java.awt.image.RasterFormatException e) { log("Skipped sharpening due to raster bounds", e); }
      }
      writeImageToFile(img, file);
    } catch (Exception e) {
      logExceptionWithFileInfo(e, file);
    } finally {
      invalidateCache(file);
    }
  }

  public static void cropImage(utils.File file, int x, int y, int width, int height) {
    try {
      javaxt.io.Image img = getOrCreateJavaxtImage(file);

      BufferedImage original = img.getBufferedImage();
      int imageType = (original.getType() == BufferedImage.TYPE_CUSTOM || original.getType() == 0)
          ? BufferedImage.TYPE_INT_ARGB : original.getType();

      BufferedImage canvas = new BufferedImage(width, height, imageType);
      Graphics2D g = canvas.createGraphics();
      // Fill with white before drawing, in case source has transparency
      g.setColor(java.awt.Color.WHITE);
      g.fillRect(0, 0, width, height);
      g.drawImage(original.getSubimage(x, y, width, height), 0, 0, null);
      g.dispose();

      writeImageToFile(new javaxt.io.Image(canvas), file);
    } catch (Exception e) {
      logExceptionWithFileInfo(e, file);
    } finally {
      invalidateCache(file);
    }
  }

  public static boolean convertToJpeg(utils.File file) { return convertToFormat(file, "jpg",  "image/jpeg"); }
  public static boolean convertToWebp(utils.File file) { return convertToFormat(file, "webp", "image/webp"); }

  public static boolean convertToFormat(utils.File file, String targetFormat, String targetMimeType) {
    if (file == null || targetFormat == null || targetMimeType == null) return false;
    try {
      if (targetMimeType.equalsIgnoreCase(file.getContentType())) {
        updateFileNameExtension(file, targetFormat);
        return true;
      }

      String ct = detectRealContentType(file);
      byte[] bytes;

      if (ct.startsWith("image/heic") || ct.startsWith("image/heif")) {
        byte[] src = readAllBytes(file.getContentStream());
        if (src == null || src.length == 0) return false;
        bytes = convertHeicToFormat(src, targetFormat);
      } else {
        javaxt.io.Image img = getOrCreateJavaxtImage(file);
        if (img == null || img.getBufferedImage() == null) return false;
        bytes = getImageBytes(img, targetFormat);
      }

      if (bytes == null || bytes.length == 0) return false;
      file.setContentStream(new ByteArrayInputStream(bytes));
      file.setContentType(targetMimeType);
      updateFileNameExtension(file, targetFormat);
      return true;
    } catch (Exception e) {
      logExceptionWithFileInfo(e, file);
      return false;
    } finally {
      invalidateCache(file);
    }
  }

  // --- Image I/O ---

  private static void writeImageToFile(javaxt.io.Image img, utils.File file) {
    try {
      String mime = detectRealContentType(file);
      String format;

      switch (mime) {
        case "image/png":  format = "png"; break;
        case "image/gif":  format = "gif"; break;
        case "image/webp": format = "webp"; break;
        case "image/heic":
        case "image/heif":
          format = "jpg";
          mime = "image/jpeg";
          break;
        default:
          javaxt.io.File xtFile = new javaxt.io.File(file.getFileName());
          String ext = xtFile.getExtension() != null ? xtFile.getExtension().toLowerCase() : "";
          if (!ext.isEmpty()) {
            format = "jpeg".equals(ext) ? "jpg" : ext;
            mime = xtFile.getContentType();
          } else {
            format = "jpg";
            mime = "image/jpeg";
          }
          break;
      }

      byte[] bytes = getImageBytes(img, format);
      file.setContentStream(new ByteArrayInputStream(bytes));
      file.setContentType(mime);
    } catch (Exception e) {
      logExceptionWithFileInfo(e, file);
    }
  }

  private static byte[] getImageBytes(javaxt.io.Image img, String format) throws Exception {
    String normalizedFormat = format.toLowerCase();

    if (normalizedFormat.equals("jpg") || normalizedFormat.equals("jpeg")) {
      img.setOutputQuality(JPG_QUALITY);
      img.setBackgroundColor(255, 255, 255);
      return img.getByteArray(normalizedFormat);
    } else if (normalizedFormat.equals("webp")) {
      java.awt.image.BufferedImage bufferedImage = img.getBufferedImage();
      javax.imageio.ImageWriter writer = javax.imageio.ImageIO.getImageWritersByMIMEType("image/webp").next();

      com.luciad.imageio.webp.WebPWriteParam writeParam = (com.luciad.imageio.webp.WebPWriteParam) writer.getDefaultWriteParam();
      writeParam.setCompressionMode(javax.imageio.ImageWriteParam.MODE_EXPLICIT);
      writeParam.setCompressionType(com.luciad.imageio.webp.CompressionType.Lossy);
      writeParam.setCompressionQuality(WEBP_QUALITY);
      writeParam.setUseSharpYUV(true);
      writeParam.setMethod(5);
      writeParam.setAutoAdjustFilterStrength(true);
      writeParam.setAlphaCompressionAlgorithm(1);

      try (java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
           javax.imageio.stream.ImageOutputStream ios = javax.imageio.ImageIO.createImageOutputStream(baos)) {
        writer.setOutput(ios);
        writer.write(null, new javax.imageio.IIOImage(bufferedImage, null, null), writeParam);
        ios.flush();
        return baos.toByteArray();
      } finally {
        writer.dispose();
      }
    } else {
      return img.getByteArray(normalizedFormat);
    }
  }

  // --- Content type detection ---

  private static String detectRealContentType(utils.File file) {
    if (file == null) return "application/octet-stream";
    try (InputStream is = file.getContentStream();
         BufferedInputStream buf = new BufferedInputStream(is)) {

      buf.mark(512);
      String fromHeader = detectImageTypeFromHeader(buf);
      buf.reset();
      if (fromHeader != null) return fromHeader;

      buf.mark(4096);
      ImageInputStream iis = ImageIO.createImageInputStream(buf);
      if (iis != null) {
        Iterator<ImageReader> readers = ImageIO.getImageReaders(iis);
        if (readers.hasNext()) {
          String[] types = readers.next().getOriginatingProvider().getMIMETypes();
          if (types != null && types.length > 0) { iis.close(); return types[0]; }
        }
        iis.close();
      }
      buf.reset();

      javaxt.io.File xtFile = new javaxt.io.File(file.getFileName());
      String ext = xtFile.getExtension() != null ? xtFile.getExtension().toLowerCase() : "";
      switch (ext) {
        case "svg":  return "image/svg+xml";
        case "webp": return "image/webp";
        case "heic": return "image/heic";
        case "heif": return "image/heif";
        default:
          String extType = xtFile.getContentType();
          return (extType != null && !extType.isEmpty()) ? extType : "application/octet-stream";
      }
    } catch (SQLException e) {
      log("Database error while fetching file content stream", e);
    } catch (IOException e) {
      log("I/O error while inspecting image codecs", e);
    }
    return "application/octet-stream";
  }

  private static String detectImageTypeFromHeader(InputStream in) throws IOException {
    if (in == null) return null;
    in.mark(512);
    byte[] h = new byte[64];
    int read = in.read(h);
    in.reset();

    if (read >= 12 && h[4]=='f' && h[5]=='t' && h[6]=='y' && h[7]=='p') {
      String[] heicBrands = {"heic","heix","hevc","hevx","mif1","msf1","heis","hevm","hevs"};
      for (int i = 8; i + 4 <= read; i += 4) {
        String brand = new String(h, i, 4, StandardCharsets.US_ASCII);
        for (String b : heicBrands) if (b.equals(brand)) return "image/heic";
      }
    }
    if (read>=12 && h[0]=='R' && h[1]=='I' && h[2]=='F' && h[3]=='F' && h[8]=='W' && h[9]=='E' && h[10]=='B' && h[11]=='P') return "image/webp";
    if (read>=8  && h[0]==(byte)0x89 && h[1]=='P' && h[2]=='N' && h[3]=='G') return "image/png";
    if (read>=6  && h[0]=='G' && h[1]=='I' && h[2]=='F' && h[3]=='8')        return "image/gif";
    if (read>=3  && h[0]==(byte)0xFF && h[1]==(byte)0xD8 && h[2]==(byte)0xFF) return "image/jpeg";
    return null;
  }

  // --- HEIC conversion ---

  public static byte[] convertHeicToJpeg(byte[] bytes) throws IOException { return convertHeicToFormat(bytes, "jpg");  }
  public static byte[] convertHeicToWebp(byte[] bytes) throws IOException { return convertHeicToFormat(bytes, "webp"); }

  private static byte[] convertHeicToFormat(byte[] heicBytes, String targetFormat) throws IOException {
    if (heicBytes == null || heicBytes.length == 0) {
      throw new IllegalArgumentException("Input image data stream cannot be empty.");
    }
    
    File tmp = File.createTempFile("heic-convert-", ".heic");
    tmp.deleteOnExit();
    try (FileOutputStream fos = new FileOutputStream(tmp)) {
      fos.write(heicBytes);
    }

    String fmt = targetFormat.equalsIgnoreCase("jpeg") ? "jpg" : targetFormat.toLowerCase();

    try (IOFileStream fs = new IOFileStream(tmp, IOMode.READ)) {
      HeicImage image = HeicImage.load(fs);
      int w = (int) image.getWidth();
      int h = (int) image.getHeight();

      // Extract the raw HEIC pixels into a Java memory canvas
      BufferedImage bi = new BufferedImage(w, h, "jpg".equals(fmt) ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB);
      bi.setRGB(0, 0, w, h, image.getInt32Array(PixelFormat.Argb32), 0, w);

      // ---------------------------------------------------------
      // THE BRIDGE: Wrap the BufferedImage into a JavaXT Image
      // ---------------------------------------------------------
      javaxt.io.Image javaxtImg = new javaxt.io.Image(bi);

      // Hand it over to your highly-optimized, centralized engine!
      return getImageBytes(javaxtImg, fmt);
    } catch (Exception e) {
      throw new IOException("Failed to unpack HEIC container: " + e.getMessage(), e);
    } finally {
      tmp.delete();
    }
  }

  // --- Helpers ---

  private static void updateFileNameExtension(utils.File file, String ext) {
    if (file == null || ext == null || ext.isEmpty()) return;
    String name = file.getFileName();
    if (name == null || name.isEmpty()) return;
    ext = ext.toLowerCase();
    int dot = name.lastIndexOf('.');
    if (dot != -1) {
      if (name.substring(dot + 1).toLowerCase().equals(ext)) return;
      file.setFileName(name.substring(0, dot) + "." + ext);
    } else {
      file.setFileName(name + "." + ext);
    }
  }

  private static byte[] readAllBytes(InputStream in) throws IOException {
    if (in == null) return new byte[0];
    try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
      byte[] buf = new byte[8192]; int n;
      while ((n = in.read(buf)) != -1) baos.write(buf, 0, n);
      return baos.toByteArray();
    }
  }

  private static void warn(utils.File file, String op) {
    org.webdsl.logging.Logger.warn("Failed to read image data for " + op + ": " + file.getFileName());
  }

  private static void log(String msg, Exception e) {
    org.webdsl.logging.Logger.error(msg, e);
  }

  private static void logExceptionWithFileInfo(Exception e, utils.File file) {
    String name = file != null ? file.getFileName() : "null";
    String ct   = file != null ? detectRealContentType(file) : "null";
    log("EXCEPTION for file: " + name + " (Content Type: " + ct + ")", e);
  }
}