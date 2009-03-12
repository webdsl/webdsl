package name.fraser.neil.plaintext;

import java.util.*;

public class patch_factory {

    static diff_match_patch the_diff_match_patch = 
	new diff_match_patch();

    public static String patchMake(String s1, String s2) {
    	return the_diff_match_patch.patchMake(s1, s2);
    }

    public static String patchApply(String patch, String s) {
    	return the_diff_match_patch.patchApply(patch, s);
    }

    public static List<String> diff(String s1, String s2) {
    	List<diff_match_patch.Diff> diffs = the_diff_match_patch.diff_main(s1, s2);
    	List<String> strings = new LinkedList<String>();
    	for(diff_match_patch.Diff d : diffs){
    		StringBuffer buf = new StringBuffer();
    		if(d.operation.equals(diff_match_patch.Operation.DELETE)){
    			buf.append("removed: ");
    			buf.append(d.text);
    			strings.add(buf.toString());
    		}
    		else if(d.operation.equals(diff_match_patch.Operation.INSERT)){
    			buf.append("added: ");
    			buf.append(d.text);
    			strings.add(buf.toString());    			
    		}
    	}
    	return strings;
    }    
    
}