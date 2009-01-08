package name.fraser.neil.plaintext;

public class patch_factory {

    static diff_match_patch the_diff_match_patch = 
	new diff_match_patch();

    public static String patchMake(String s1, String s2) {
	return the_diff_match_patch.patchMake(s1, s2);
    }

    public static String patchApply(String patch, String s) {
	return the_diff_match_patch.patchApply(patch, s);
    }

}