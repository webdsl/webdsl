package utils;

public class LocalTemplateArguments {
    public LocalTemplateArguments(Object[] extraArgs, String spanName, String spanNameUnique) {
        this.extraArgs = extraArgs;
        this.spanName = spanName;
        this.spanNameUnique = spanNameUnique;
    }
    public Object[] extraArgs;
    public String spanName;
    public String spanNameUnique;
}
