package utils;

import java.util.ArrayList;
import java.util.List;

public class Navigate {

	public static final List<String> emptyargs = new ArrayList<String>(0);

	public static String constructUrl(String pagename) {
		return constructUrl(pagename,emptyargs);
	}

	public static String constructUrl(String pagename, List<String> args, String... argtypes) {
		StringBuilder sb = new StringBuilder(256);
		String applicationURL = ThreadLocalPage.get().getAbsoluteLocation();

		List<String> routingapplied = Routing.processNavigate(applicationURL, pagename, args);
		if(routingapplied == null){
			sb
			.append(applicationURL)
			.append("/")
			.append(pagename);
			removeTrailingDefaultValues(args,argtypes);
			
			for(String arg : args){
				sb.append("/").append(arg);				
			}
		}
		else{
			boolean first = true;
			for(String arg : routingapplied){
				if(!first){	sb.append("/");	} else { first = false;	}
				sb.append(arg);				
			}
		}
		
		return utils.HTMLFilter.filter(sb.toString());
	}

	public static void removeTrailingDefaultValues(List<String> args, String... argtypes){
        for(int i = args.size() - 1; i >= 0; i--){
			if(   (args.get(i).equals("") && utils.TypesInfo.getStringCompatibleTypes().contains(argtypes[i]))
			   || (args.get(i).equals("0") && argtypes[i].equals("Int"))
			   || (args.get(i).equals("0.0") && argtypes[i].equals("Float"))
			){
				args.remove(i); 
			}
			else{
				break; // stop when non-default value is at the end
			}
		}
	}

}
