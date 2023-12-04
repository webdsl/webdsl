package utils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RegexType {

	public static List<String> groups(String pattern, String s) {
		Matcher m = Pattern.compile(pattern).matcher(s);
		if (m.find()) {
			return createGroupList(m);
		} else {
			return new ArrayList<String>();
		}
	}

	public static List<List<String>> allGroups(String pattern, String s) {
		Matcher m = Pattern.compile(pattern).matcher(s);
		List<List<String>> result = new ArrayList<List<String>>();
		while (m.find()) {
			result.add(createGroupList(m));
		}
		return result;
	}

	public static List<String> createGroupList(Matcher m) {
		List<String> result = new ArrayList<String>();
		result.add(m.group(0));
		int total = m.groupCount();
		int index = 0;
		while (index < total) {
			index++;
			result.add(m.group(index));
		}
		return result;
	}
}
