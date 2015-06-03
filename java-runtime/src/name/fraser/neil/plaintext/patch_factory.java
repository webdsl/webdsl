package name.fraser.neil.plaintext;

import java.util.LinkedList;
import java.util.List;

import name.fraser.neil.plaintext.diff_match_patch.Diff;
import name.fraser.neil.plaintext.diff_match_patch.Operation;
import name.fraser.neil.plaintext.diff_match_patch.Patch;

public class patch_factory {

    static diff_match_patch the_diff_match_patch = 
	new diff_match_patch();

    public static String patchMake(String s1, String s2) {
    	return the_diff_match_patch.patch_toText(the_diff_match_patch.patch_make(s1, s2));
    }

    public static String patchApply(String patch, String s) {
    	return (String) the_diff_match_patch.patch_apply(the_diff_match_patch.patch_fromText(patch), s)[0];
    }

    public static List<String> diff(String s1, String s2) {
    	List<diff_match_patch.Diff> diffs = the_diff_match_patch.diff_main(s1, s2);
    	List<String> strings = new LinkedList<String>();
    	for(diff_match_patch.Diff d : diffs){
    		if(d.operation.equals(diff_match_patch.Operation.DELETE)){
    			strings.add( "removed: " + d.text);
    		}
    		else if(d.operation.equals(diff_match_patch.Operation.INSERT)){
    			strings.add( "added: " + d.text); 			
    		}
    	}
    	return strings;
    }   
    public static String diffHTML(String patch, boolean inverse) {
    	LinkedList<Patch> patches = the_diff_match_patch.patch_fromText(patch);
    	if(inverse){
    		invertPatch(patches);
    	}
    	StringBuilder sb = new StringBuilder();
    	for (Patch patch2 : patches) {
			sb.append(the_diff_match_patch.diff_prettyHtml(patch2.diffs));
		}
    	return sb.toString();
    }
    
    public static void invertPatch(LinkedList<Patch> patches) {
    	for (Patch patch2 : patches) {
			for(Diff d : patch2.diffs){
				if(d.operation.equals(Operation.DELETE)){
					d.operation = Operation.INSERT;
				} else if (d.operation.equals(Operation.INSERT)){
					d.operation = Operation.DELETE;
				}
				
			}
		}
    }
    
    public static String unpatchApply(String patch, String s){
    	//swap DIFF_INSERT with DIFF_DELETE and vice versa
    	LinkedList<Patch> patches = the_diff_match_patch.patch_fromText(patch);
    	invertPatch(patches);
    	return (String) the_diff_match_patch.patch_apply(patches, s)[0];
    	

    }
}