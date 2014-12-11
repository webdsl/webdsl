package utils;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class PageStats {
	public String pagename;
	public int readOnly;
	public int readOnlyFromCache;
	public int withUpdates;
	public int actionFailed;
	public int actionSuccessReadOnly;
	public int actionSuccessWithUpdates;
	public PageStats setPage(String p){
		pagename = p;
		return this;
	}
	public PageStats setReadOnly(int r){
		readOnly = r;
		return this;
	}
	public PageStats setReadOnlyFromCache(int r){
		readOnlyFromCache = r;
		return this;
	}
	public PageStats setWithUpdates(int r){
		withUpdates = r;
		return this;
	}
	public PageStats setActionFailed(int r){
		actionFailed = r;
		return this;
	}
	public PageStats setActionSuccessReadOnly(int r){
		actionSuccessReadOnly = r;
		return this;
	}
	public PageStats setActionSuccessWithUpdates(int r){
		actionSuccessWithUpdates = r;
		return this;
	}
	public int total(){
		return readOnly + readOnlyFromCache + withUpdates + actionFailed + actionSuccessReadOnly + actionSuccessWithUpdates;
	}
	public static final String tableFormat = "%1$30s | %2$12s | %3$12s | %4$12s | %5$12s | %6$12s | %7$12s | %8$12s";
	public String toString(){
		return String.format(tableFormat, pagename, total(), readOnlyFromCache, readOnly, withUpdates, actionSuccessReadOnly, actionSuccessWithUpdates, actionFailed);
	}
	public static void printList(List<PageStats> stats){
		StringBuilder sb = new StringBuilder(1536);
		sb.append("\n")
		.append("Start 5 minute page request statistics")
		.append("\n")
		.append(String.format(tableFormat, "page", "total", "request", "request", "request", "action", "action", "action"))
		.append("\n")
		.append(String.format(tableFormat, "name", "requests", "from cache", "read-only", "with updates", "read-only", "with updates", "failed"))
		.append("\n")
		.append(String.format(tableFormat, "------------------------------", "------------", "------------", "------------", "------------", "------------", "------------", "------------"));
		Collections.sort(stats, new Comparator<PageStats>() {
			public int compare(PageStats p1, PageStats p2) {
				return new Integer(p2.total()).compareTo(p1.total());
			}
		});
		for(int i = 0; i < Math.min(10, stats.size()) ;i++){
			PageStats ps = stats.get(i);
			sb.append("\n").append(ps);
		}
		sb.append("\n")
		.append("End page request statistics");
		
		org.webdsl.logging.Logger.info(sb);
	}
}