package utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;

public class InputStreamReader {
    public static String readStream(InputStream is) {
        if (is != null) {
            StringBuilder sb = new StringBuilder(256);
            String line;
            try {
                BufferedReader reader = new BufferedReader(new java.io.InputStreamReader(is));
                while ((line = reader.readLine()) != null) {
                    sb.append(line).append("\n");
                }
            } catch (IOException e) {
            } finally {
            }
            return sb.toString();
        } else {
            return "";
        }
    }

    public static String readBody() {
        try {
            return utils.InputStreamReader.readStream(ThreadLocalPage.get().getRequest().getInputStream());
        } catch (IOException e) {
            return null;
        }
    }
}
