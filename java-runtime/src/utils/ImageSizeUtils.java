package utils;

import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
import java.io.*;
import java.util.*;
import org.hibernate.Session;

import javax.imageio.ImageIO;

public class ImageSizeUtils {
    public static BufferedImage getScaledInstance(BufferedImage img, int targetWidth,
            int targetHeight, Object hint, boolean higherQuality) {
        int type = (img.getTransparency() == Transparency.OPAQUE) ? BufferedImage.TYPE_INT_RGB
                : BufferedImage.TYPE_INT_ARGB;
        BufferedImage ret = (BufferedImage) img;
        int w, h;
        if (higherQuality) {
            w = img.getWidth();
            h = img.getHeight();
        } else {
            w = targetWidth;
            h = targetHeight;
        }

        do {
            if (higherQuality && w > targetWidth) {
                w /= 2;
                if (w < targetWidth) {
                    w = targetWidth;
                }
            }
            if (higherQuality && h > targetHeight) {
                h /= 2;
                if (h < targetHeight) {
                    h = targetHeight;
                }
            }
            BufferedImage tmp = new BufferedImage(w, h, type);
            Graphics2D g2 = tmp.createGraphics();
            g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, hint);
            g2.drawImage(ret, 0, 0, w, h, null);
            g2.dispose();
            ret = tmp;
        } while (w != targetWidth || h != targetHeight);

        return ret;
    }

    public static void resizeImage(Session session, utils.File file, int width, int height) {
        try {
            session.refresh(file);
            BufferedImage img = ImageIO.read(file.getContentStream());
            if(width == 0) {
                width = img.getWidth();
            }
            if(height == 0) {
                height = img.getHeight();
            }
            if(width > img.getWidth()) {
                width = img.getWidth();
            }
            if(height > img.getHeight()) {
                height = img.getHeight();
            }
            if((float)height/(float)img.getHeight() > (float)width/(float)img.getWidth()) {
                float factor = (float)width/(float)img.getWidth();
                int newWidth=(int)(factor*(float)img.getWidth());
                int newHeight=(int)(factor*(float)img.getHeight());
                img = getScaledInstance(img, newWidth, newHeight, RenderingHints.VALUE_INTERPOLATION_BILINEAR, true);
            } else {
                float factor = (float)height/(float)img.getHeight();
                int newWidth=(int)(factor*(float)img.getWidth());
                int newHeight=(int)(factor*(float)img.getHeight());
                img = getScaledInstance(img, newWidth, newHeight, RenderingHints.VALUE_INTERPOLATION_BILINEAR, true);
            }
            
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            if(file.getFileName().endsWith(".png")) {
                ImageIO.write(img, "png", out);
            } else {
                ImageIO.write(img, "jpg", out);
            }
            file.setContentStream(session, new ByteArrayInputStream(out.toByteArray()));
            if(!file.getFileName().endsWith(".png")) {
                file.setContentType("image/jpeg");
            }
            session.flush();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void cropImage(Session session, utils.File file, int x, int y, int width, int height) {
        try {
            session.refresh(file);
            BufferedImage img = ImageIO.read(file.getContentStream());
            img = img.getSubimage(x, y, width, height);
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            if(file.getFileName().endsWith(".png")) {
                ImageIO.write(img, "png", out);
            } else {
                ImageIO.write(img, "jpg", out);
            }
            file.setContentStream(session, new ByteArrayInputStream(out.toByteArray()));
            if(!file.getFileName().endsWith(".png")) {
                file.setContentType("image/jpeg");
            }
            session.flush();
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
    
    
    public static int getWidth(Session session, utils.File file) {
        try {
            session.refresh(file);
            BufferedImage img = ImageIO.read(file.getContentStream());
            return img.getWidth();
        } catch(Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static int getHeight(Session session, utils.File file) {
        try {
            session.refresh(file);
            BufferedImage img = ImageIO.read(file.getContentStream());
            return img.getHeight();
        } catch(Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
