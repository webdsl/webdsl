package utils;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class PageStats {
	public String pagename;
	public int readOnly;
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
		return readOnly + withUpdates + actionFailed + actionSuccessReadOnly + actionSuccessWithUpdates;
	}
	public static final String tableFormat = "%1$30s | %2$12s | %3$12s | %4$12s | %5$12s | %6$12s | %7$12s";
	public String toString(){
		return String.format(tableFormat, pagename, total(), readOnly, withUpdates, actionSuccessReadOnly, actionSuccessWithUpdates, actionFailed);
	}
	public static void printList(List<PageStats> stats){
		System.out.println("Start 5 minute page request statistics");
		System.out.println(String.format(tableFormat, "page", "total", "request", "request", "action", "action", "action"));
		System.out.println(String.format(tableFormat, "name", "requests", "read-only", "with updates", "read-only", "with updates", "failed"));
		System.out.println(String.format(tableFormat, "------------------------------", "------------", "------------", "------------", "------------", "------------", "------------"));
		Collections.sort(stats, new Comparator<PageStats>() {
			public int compare(PageStats p1, PageStats p2) {
				return new Integer(p2.total()).compareTo(p1.total());
			}
		});
		for(int i = 0; i < Math.min(10, stats.size()) ;i++){
			PageStats ps = stats.get(i);
			System.out.println(ps);
		}
		System.out.println("End page request statistics");
	}
}