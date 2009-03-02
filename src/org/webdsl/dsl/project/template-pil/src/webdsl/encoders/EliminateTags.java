package webdsl.encoders;

public class EliminateTags {
    public static String eliminateTags(String html) {
        return html.replaceAll("<[^>]*>","");
    }
}