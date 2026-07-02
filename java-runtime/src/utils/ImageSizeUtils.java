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
import java.awt.RenderingHints;
import java.awt.color.ColorSpace;
import java.awt.image.BufferedImage;
import java.awt.image.ColorConvertOp;
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

/**
 * Utility class for handling image transformations, size detection, and format conversion.
 * Features a single-pass execution pipeline for unified resizing and modern codec encoding.
 */
public class ImageSizeUtils {

    // --- Configuration Settings ---
    private static final double JPG_QUALITY = 0.85;
    
    /**
     * WEBP_QUALITY = 0.88f
     * 88% quality is empirically determined to provide a strong balance between file size reduction and visual fidelity for photographic content.
     * Note: If images experience subtle green/pink tints in flat gradients (like skies), 
     * raising this parameter past 0.91f relaxes chroma quantization step sizes completely.
     */
    private static final float WEBP_QUALITY = 0.88f;

    // --- Cache Infrastructure ---
    // Employs weak keys to ensure File references can be garbage collected when out of scope.
    private static final Cache<utils.File, ImageMetadata> metadataCache = 
            CacheBuilder.newBuilder().weakKeys().build();

    private static final class ImageMetadata {
        final String contentType;
        final int width;
        final int height;
        final javaxt.io.Image image;

        ImageMetadata(String contentType, javaxt.io.Image image) {
            this.contentType = contentType;
            this.image = image;
            this.width = (image != null && image.getBufferedImage() != null) ? image.getWidth() : 0;
            this.height = (image != null && image.getBufferedImage() != null) ? image.getHeight() : 0;
        }
    }

    // --- Cache Management ---

    public static void invalidateCache(utils.File file) {
        metadataCache.invalidate(file);
    }

    private static ImageMetadata getMetadata(utils.File file) {
        try {
            return metadataCache.get(file, () -> {
                String ct = detectRealContentType(file);
                
                // Lazy conversion branch for HEIC/HEIF files to standard JPEG structures
                if (ct.startsWith("image/heic") || ct.startsWith("image/heif")) {
                    byte[] src = readAllBytes(file.getContentStream());
                    
                    // Decode the HEIC source data directly into an in-memory canvas
                    javaxt.io.Image heicImg = decodeHeicToImage(src);
                    byte[] jpg = getImageBytes(heicImg, "jpg");
                    
                    // Persist mutated properties back to the underlying container object
                    file.setContentStream(new ByteArrayInputStream(jpg));
                    file.setContentType("image/jpeg");
                    updateFileNameExtension(file, "jpg");
                    
                    return new ImageMetadata("image/jpeg", heicImg);
                }
                return new ImageMetadata(ct, loadJavaxtImage(file));
            });
        } catch (Exception e) {
            logExceptionWithFileInfo(e, file);
            return new ImageMetadata("application/octet-stream", null);
        }
    }

    /**
     * Ingests the raw stream into an image container and forces an immediate normalization pass
     * if the incoming file utilizes an indexed palette or an unmapped custom layout.
     */
    private static javaxt.io.Image loadJavaxtImage(utils.File file) throws IOException {
        try {
            javaxt.io.Image img = new javaxt.io.Image(file.getContentStream());
            return ensureTrueColor(img);
        } catch (SQLException e) {
            throw new IOException("Failed to open content stream", e);
        }
    }

    /**
     * CANVAS NORMALIZATION LAYER:
     * Evaluates if the incoming image asset is constrained to a packed palette (IndexColorModel),
     * a binary matrix, or a custom unmapped space. If true, it extracts and paints the image onto
     * a 32-bit sRGB TrueColor canvas with full alpha-channel fidelity. This ensures that downsampling, 
     * sharpening, or cropping routines never experience palette quantization errors or transparent bleeding.
     */
    private static javaxt.io.Image ensureTrueColor(javaxt.io.Image img) {
        if (img == null || img.getBufferedImage() == null) return img;
        
        BufferedImage bi = img.getBufferedImage();
        int type = bi.getType();

        if (type == BufferedImage.TYPE_BYTE_INDEXED || 
            type == BufferedImage.TYPE_BYTE_BINARY || 
            type == BufferedImage.TYPE_CUSTOM || 
            type == 0 || 
            bi.getColorModel() instanceof java.awt.image.IndexColorModel) {

            BufferedImage trueColor = new BufferedImage(
                bi.getWidth(), 
                bi.getHeight(), 
                BufferedImage.TYPE_INT_ARGB
            );
            
            Graphics2D g2d = trueColor.createGraphics();
            try {
                g2d.setComposite(java.awt.AlphaComposite.Src);
                g2d.drawImage(bi, 0, 0, null);
            } finally {
                g2d.dispose();
            }
            return new javaxt.io.Image(trueColor);
        }
        return img;
    }

    private static javaxt.io.Image getOrCreateJavaxtImage(utils.File file) throws IOException {
        javaxt.io.Image img = getMetadata(file).image;
        if (img == null) {
            throw new IOException("Failed to load image for file: " + file.getFileName());
        }
        return img;
    }

    // --- Public Structural Accessors ---

    public static String getRealContentType(utils.File file) { return getMetadata(file).contentType; }
    public static int getWidth(utils.File file)             { return getMetadata(file).width; }
    public static int getHeight(utils.File file)            { return getMetadata(file).height; }

    public static javaxt.io.Image createJavaxtImageFromFile(utils.File file) throws IOException {
        if (file == null) return null;
        return getOrCreateJavaxtImage(file);
    }

    // --- Unified Single-Pass Entrypoints ---

    public static boolean resizeAndConvertToWebp(utils.File file, int width, int height) {
        return resizeAndConvertToFormat(file, width, height, "webp", "image/webp");
    }

    public static boolean resizeAndConvertToJpeg(utils.File file, int width, int height) {
        return resizeAndConvertToFormat(file, width, height, "jpg", "image/jpeg");
    }

    public static boolean convertToJpeg(utils.File file) { return convertToFormat(file, "jpg", "image/jpeg"); }
    public static boolean convertToWebp(utils.File file) { return convertToFormat(file, "webp", "image/webp"); }

    /**
     * Legacy conversion fallback wrapper. Routes parameters to the unified scaling method
     * with 0 bounds, ensuring images are converted without altering original dimensions.
     */
    public static boolean convertToFormat(utils.File file, String targetFormat, String targetMimeType) {
        return resizeAndConvertToFormat(file, 0, 0, targetFormat, targetMimeType);
    }

    /**
     * Centralized Image Pipeline Core. Combines format conversions and optional dimensions processing
     * to eliminate repetitive file updates, double encoding iterations, and memory churn.
     */
    public static boolean resizeAndConvertToFormat(utils.File file, int requestedWidth, int requestedHeight, String targetFormat, String targetMimeType) {
        if (file == null || targetFormat == null || targetMimeType == null) return false;
        try {
            // Fast-Path Optimization: Skip processing loop if file matches final specifications
            if (targetMimeType.equalsIgnoreCase(file.getContentType()) && requestedWidth <= 0 && requestedHeight <= 0) {
                updateFileNameExtension(file, targetFormat);
                return true;
            }

            String ct = detectRealContentType(file);
            javaxt.io.Image img;

            // Extract target image source based on codec origins
            if (ct.startsWith("image/heic") || ct.startsWith("image/heif")) {
                byte[] src = readAllBytes(file.getContentStream());
                if (src == null || src.length == 0) return false;
                img = decodeHeicToImage(src);
            } else {
                img = getOrCreateJavaxtImage(file);
            }

            if (img == null || img.getBufferedImage() == null) return false;

            // Conditional Resizing Layer: Modifies canvas size on-demand if dimensions are passed
            if (requestedWidth > 0 || requestedHeight > 0) {
                scaleAndSharpenImage(img, requestedWidth, requestedHeight);
            }

            // High Performance Encoding Step
            byte[] bytes = getImageBytes(img, targetFormat);
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

    // --- Mutating Operations ---

    public static void resizeImage(utils.File file, int width, int height) {
        try {
            javaxt.io.Image img = getOrCreateJavaxtImage(file);
            scaleAndSharpenImage(img, width, height);
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
            
            /*
             * CANVAS NORMALIZATION STRATEGY:
             * When reading source images, Java standardizes many formats into BufferedImage.TYPE_CUSTOM (type 0).
             * Attempting to perform raw canvas mutations, sub-image clipping, or rendering on a TYPE_CUSTOM 
             * layout directly breaks OS-level hardware pipelines, corrupts alpha masks, or shifts colors.
             *
             * FIX: We detect custom layouts and explicitly force a fresh, predictable 32-bit canvas buffer 
             * (TYPE_INT_ARGB). This ensures the underlying Graphics2D environment operates with native integer 
             * byte packing, safeguarding original color data throughout the subimage extraction pass.
             */
            int imageType = (original.getType() == BufferedImage.TYPE_CUSTOM || original.getType() == 0)
                    ? BufferedImage.TYPE_INT_ARGB : original.getType();

            BufferedImage canvas = new BufferedImage(width, height, imageType);
            Graphics2D g = canvas.createGraphics();
            
            // Fixes transparent background bleed: defaults empty canvas fields to pure solid white
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

    // --- Private Shared Helper Utilities ---

    /**
     * Shared calculation method to resize images while safely adhering to bounding box constraints,
     * maintaining proportional aspect ratios, and avoiding empty raster dimension processing.
     */
    private static void scaleAndSharpenImage(javaxt.io.Image img, int requestedWidth, int requestedHeight) {
        int width = requestedWidth;
        int height = requestedHeight;

        if (width == 0 || width > img.getWidth())   width = img.getWidth();
        if (height == 0 || height > img.getHeight()) height = img.getHeight();

        float factor = ((float) height / img.getHeight() > (float) width / img.getWidth())
                ? (float) width / img.getWidth()
                : (float) height / img.getHeight();

        img.resize(Math.round(factor * img.getWidth()), Math.round(factor * img.getHeight()), true);

        if (img.getWidth() > 2 && img.getHeight() > 2) {
            try { 
                img.sharpen(); 
            } catch (java.awt.image.RasterFormatException e) { 
                log("Skipped sharpening due to raster bounds", e); 
            }
        }
    }

    // --- Image Serialization & Writer Subsystem ---

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
            BufferedImage bufferedImage = img.getBufferedImage();

            // 1. WEBP HARD LIMIT: libwebp fundamentally rejects images exceeding 16383 pixels.
            // Clamp and proportionally scale down massive corporate logo files.
            int maxDim = 16383;
            int width = bufferedImage.getWidth();
            int height = bufferedImage.getHeight();
            
            if (width > maxDim || height > maxDim) {
                float scale = Math.min((float) maxDim / width, (float) maxDim / height);
                width = Math.round(width * scale);
                height = Math.round(height * scale);
                org.webdsl.logging.Logger.warn("Image exceeds WebP limits. Clamping dimensions to: " + width + "x" + height);
            }
            int targetType = bufferedImage.getColorModel().hasAlpha() 
                    ? BufferedImage.TYPE_INT_ARGB 
                    : BufferedImage.TYPE_INT_RGB;
                    
            BufferedImage standardized = new BufferedImage(
                    width, 
                    height, 
                    targetType
            );

            /*
             * COLOR SPACE SHIFT FIX (COLORCONVERTOP):
             * Standard Graphics2D drawing discards embedded color profiles, corrupting the gamma curve mapping
             * of shadows and skies. To fix this, we check if the image utilizes a non-standard color model.
             * If it does, we use ColorConvertOp to map coordinates accurately into sRGB space. If it's already
             * standard, we draw using ultra-high-quality scaling and rendering hints.
             */
            if (bufferedImage.getColorModel().getColorSpace().getType() != ColorSpace.TYPE_RGB) {
                ColorConvertOp op = new ColorConvertOp(ColorSpace.getInstance(ColorSpace.CS_sRGB), null);
                op.filter(bufferedImage, standardized);
            } else {
                Graphics2D g2d = standardized.createGraphics();
                g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
                g2d.setRenderingHint(RenderingHints.KEY_COLOR_RENDERING, RenderingHints.VALUE_COLOR_RENDER_QUALITY);
                g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);
                g2d.drawImage(bufferedImage, 0, 0, null);
                g2d.dispose();
            }
            
            bufferedImage = standardized;

            javax.imageio.ImageWriter writer = null;
            java.util.Iterator<javax.imageio.ImageWriter> writers = ImageIO.getImageWritersByMIMEType("image/webp");
            
            while (writers.hasNext()) {
                javax.imageio.ImageWriter w = writers.next();
                try {
                    // Using instanceof safely screens out writers belonging to another web app.
                    // If the writer belongs to a different classloader, this evaluates to false.
                    if (w.getDefaultWriteParam() instanceof com.luciad.imageio.webp.WebPWriteParam) {
                        writer = w;
                        break;
                    }
                } catch (Throwable t) {
                    // Bypasses any unstable or conflicting registration states
                }
            }

            if (writer == null) {
                throw new java.io.IOException("No WebP ImageWriter found matching this application's ClassLoader context.");
            }
            com.luciad.imageio.webp.WebPWriteParam writeParam = (com.luciad.imageio.webp.WebPWriteParam) writer.getDefaultWriteParam();
            
            // Native Configuration Binding Pass
            writeParam.setCompressionMode(javax.imageio.ImageWriteParam.MODE_EXPLICIT);
            writeParam.setCompressionType(com.luciad.imageio.webp.CompressionType.Lossy);
            
            /*
             * setFilterType(0) -> Simple Loop Filter
             * Why we choose this: At qualities lower than 91%, the Strong Filter (1) aggressively averages 
             * pixel boundaries across macroblocks, causing massive spatial color bleeding. This manifests as
             * unnatural green/pink hue shifts over sensitive skin tones and flat sky gradients. 
             * Setting this to 0 (Simple) forces the encoder to restrict filter alterations to literal edge 
             * boundaries, keeping interior macroblock colors untouched.
             */
            writeParam.setFilterType(0); 
            writeParam.setCompressionQuality(WEBP_QUALITY);
            
            /*
             * setUseSharpYUV(true)
             * Why we choose this: Forces the encoder to apply a sophisticated, iterative preprocessing algorithm 
             * during RGB to YUV 4:2:0 downsampling. It corrects color positioning errors before structural data 
             * destruction, preserving sharp definition around architectural skylines and fine facial details.
             */
            writeParam.setUseSharpYUV(true);
            writeParam.setMethod(4);
            // writeParam.setAutoAdjustFilterStrength(true);

            // writeParam.setAutoAdjustFilterStrength(false); // Stop the encoder from over-filtering colors
            writeParam.setFilterStrength(0);//12             // Low strength keeps boundaries sharp (0 is off)
            writeParam.setFilterSharpness(0);        
            writeParam.setAlphaCompressionAlgorithm(1);

            try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
                 javax.imageio.stream.ImageOutputStream ios = ImageIO.createImageOutputStream(baos)) {
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

    // --- Comprehensive Header & Mime Identification ---

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
                    if (types != null && types.length > 0) { 
                        iis.close(); 
                        return types[0]; 
                    }
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

        if (read >= 12 && h[4] == 'f' && h[5] == 't' && h[6] == 'y' && h[7] == 'p') {
            String[] heicBrands = {"heic","heix","hevc","hevx","mif1","msf1","heis","hevm","hevs"};
            for (int i = 8; i + 4 <= read; i += 4) {
                String brand = new String(h, i, 4, StandardCharsets.US_ASCII);
                for (String b : heicBrands) if (b.equals(brand)) return "image/heic";
            }
        }
        if (read >= 12 && h[0] == 'R' && h[1] == 'I' && h[2] == 'F' && h[3] == 'F' && h[8] == 'W' && h[9] == 'E' && h[10] == 'B' && h[11] == 'P') return "image/webp";
        if (read >= 8  && h[0] == (byte)0x89 && h[1] == 'P' && h[2] == 'N' && h[3] == 'G') return "image/png";
        if (read >= 6  && h[0] == 'G' && h[1] == 'I' && h[2] == 'F' && h[3] == '8')        return "image/gif";
        if (read >= 3  && h[0] == (byte)0xFF && h[1] == (byte)0xD8 && h[2] == (byte)0xFF) return "image/jpeg";
        return null;
    }

    // --- Isolated HEIC Extraction ---

    private static javaxt.io.Image decodeHeicToImage(byte[] heicBytes) throws IOException {
        if (heicBytes == null || heicBytes.length == 0) {
            throw new IllegalArgumentException("Input image data stream cannot be empty.");
        }
        
        File tmp = File.createTempFile("heic-convert-", ".heic");
        tmp.deleteOnExit();
        try (FileOutputStream fos = new FileOutputStream(tmp)) {
            fos.write(heicBytes);
        }

        int defaultType = BufferedImage.TYPE_INT_ARGB;

        try (IOFileStream fs = new IOFileStream(tmp, IOMode.READ)) {
            HeicImage image = HeicImage.load(fs);
            int w = (int) image.getWidth();
            int h = (int) image.getHeight();

            BufferedImage bi = new BufferedImage(w, h, defaultType);
            int[] dstArray = ((java.awt.image.DataBufferInt) bi.getRaster().getDataBuffer()).getData();
            int[] pixels = image.getInt32Array(PixelFormat.Argb32, dstArray);

            if (pixels == null) {
                java.util.Map<Long, openize.heic.decoder.HeicImageFrame> frames = image.getFrames();
                if (frames != null && !frames.isEmpty()) {
                    for (openize.heic.decoder.HeicImageFrame frame : frames.values()) {
                        w = (int) frame.getWidth();
                        h = (int) frame.getHeight();
                        bi = new BufferedImage(w, h, defaultType);
                        dstArray = ((java.awt.image.DataBufferInt) bi.getRaster().getDataBuffer()).getData();
                        pixels = frame.getInt32Array(PixelFormat.Argb32, dstArray);
                        if (pixels != null) break;
                    }
                }
            }

            if (pixels == null) {
                throw new IOException("The Openize decoder returned null pixel data. This specific HEIC variant cannot be processed.");
            }

            if (pixels != dstArray) {
                bi.setRGB(0, 0, w, h, pixels, 0, w);
            }

            return new javaxt.io.Image(bi);
        } catch (Exception e) {
            if (e instanceof IOException) throw (IOException) e;
            throw new IOException("Failed to unpack HEIC container: " + e.getMessage(), e);
        } finally {
            tmp.delete();
        }
    }

    // --- Logging & Base System Helpers ---

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
            byte[] buf = new byte[8192]; 
            int n;
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