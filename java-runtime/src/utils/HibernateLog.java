package utils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.StringReader;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Stack;

public class HibernateLog {
	protected List<HibernateLogEntry> _list = null;
	protected long _totalTime = 0;
	protected String _error = null;

	public static void printHibernateLog(PrintWriter sout, org.hibernate.Session session) {
		NDCAppender ndcAppender = NDCAppender.getNamed("hibernateLog");
		if(ndcAppender != null) { 
			String log = ndcAppender.getLog();
			HibernateLog hibLog = new HibernateLog();
			if(hibLog.tryParse(log)) {
				hibLog.print(sout, session);
			}
			else {
				hibLog.print(sout, session);
				sout.print("<pre>" + utils.HTMLFilter.filter(log) + "</pre>");
			}
		}
	}

	public HibernateLog() {
		
	}

	public boolean tryParse(String str) {
		return tryParse(new BufferedReader(new StringReader(str)));
    }

    public boolean tryParse(InputStream in) {
    	return tryParse(new BufferedReader(new InputStreamReader(in)));
    }

    public boolean tryParse(BufferedReader rdr) {
		try {
			parse(rdr);
			return true;
		}
		catch(ParseException ex) {
			_error = ex.getMessage() + " at line " + ex.getErrorOffset();
		}
		catch(IOException ex) {
			_error = ex.toString();
		}
		catch(Exception ex) {
			_error = ex.toString();
		}
		return false;
	}

	public void parse(String str) throws IOException, ParseException {
        parse(new BufferedReader(new StringReader(str)));
    }

    public void parse(InputStream in) throws IOException, ParseException {
        parse(new BufferedReader(new InputStreamReader(in)));
    }

    public void parse(BufferedReader rdr) throws IOException, ParseException {
        SimpleDateFormat absoluteFormat = new SimpleDateFormat("HH:mm:ss,SSS");
        org.hibernate.jdbc.util.BasicFormatterImpl sqlFormat = new org.hibernate.jdbc.util.BasicFormatterImpl();
        String line;
        int linenr = 0;
        _list = new ArrayList<HibernateLogEntry>();
        _totalTime = 0;
        Stack<HibernateLogEntry> entries = new Stack<HibernateLogEntry>();
        HibernateLogEntry current = null;
        while((line = rdr.readLine()) != null) {
        	linenr++;
        	int sep1 = line.indexOf("|");
        	int sep2 = line.indexOf("|", sep1 + 1);
        	if(sep1 < 0 || sep2 < 0) throw new ParseException("Incorrect layout pattern detected", linenr);
        	String cat = line.substring(0, sep1);
        	String time = line.substring(sep1 + 1, sep2);
        	String msg = line.substring(sep2 + 1);
        	if(cat.indexOf("org.hibernate.jdbc") == 0) {
        		if(msg.indexOf("about to open PreparedStatement") == 0) {
        			if(current != null) entries.push(current);
        			current = new HibernateLogEntry();
        			current.openTime = absoluteFormat.parse(time);
        			_list.add(current);
        		}
        		else if(msg.indexOf("about to close PreparedStatement") == 0) {
        			if(current == null) throw new ParseException("No statement to close", linenr);
        			current.closeTime = absoluteFormat.parse(time);
        			current.durationInclusive = dateDiff(current.openTime, current.closeTime);
        			current.durationExclusive = current.durationInclusive;
        			_totalTime += current.durationInclusive;
        			if(entries.empty()) {
        				current = null;
        			}
        			else {
        				HibernateLogEntry next = entries.pop();
        				current.subEntries = next.subEntries + 1;
        				current.durationExclusive -= next.durationInclusive;
        				_totalTime -= next.durationInclusive;
        				current = next;
        			}
        		}
        	}
        	else if(cat.indexOf("org.hibernate.SQL") == 0) {
        		if(current == null || current.sql != null) throw new ParseException("Statement was not expected", linenr);
       			current.sql = sqlFormat.format(msg);
        	}
        	else if(cat.indexOf("org.hibernate.type") == 0) {
        		if(current == null) continue;
        		if(msg.indexOf("binding parameter [") == 0) {
        			int idx = msg.indexOf("] as [");
        			if(idx <= 19) continue;
        			int index = Integer.parseInt(msg.substring(19,  idx));
        			int idx2 = msg.indexOf("] - ", idx);
        			String type = msg.substring(idx + 6, idx2);
        			String value = msg.substring(idx2 + 4);
        			if(type.equals("VARCHAR")) value = "'" + value + "'";
        			while(current.parameterVals.size() - 1 < index - 1)
        			{
        				current.parameterVals.add("<null>");
        				current.parameterTypes.add("null");            				
        			}
        			current.parameterVals.set(index - 1, value);
        			current.parameterTypes.set(index - 1, type);
        		}
        		/*  // Parsing for Hibernate 3.5.4:
        		if(msg.indexOf("binding ") == 0) {
        			int idx = msg.indexOf(" to parameter: ", 8);
        			if(idx < 0) continue;
        			String value = msg.substring(8, idx);
        			int index = Integer.parseInt(msg.substring(idx + 15));
        			idx = cat.lastIndexOf(".");
        			String type = cat.substring(idx + 1);
        			while(current.parameterVals.size() - 1 < index - 1)
        			{
        				current.parameterVals.add("null");
        				current.parameterTypes.add("null");            				
        			}
        			current.parameterVals.set(index - 1, value);
        			current.parameterTypes.set(index - 1, type);
        		}
        		*/
        	}
        }
        if(!entries.empty()) throw new ParseException("Not all statements were closed", linenr);
    }

	public void print(PrintWriter sout, org.hibernate.Session session) {
		sout.print("<hr />");
		if(_error != null) {
			sout.print("<pre class=\"sqllogexception\">" + utils.HTMLFilter.filter(_error) + "</pre>");
			return;
		}
		try {
			int logindex = 0;
			java.util.List<utils.HibernateLogEntry> longestThree = new java.util.ArrayList<utils.HibernateLogEntry>();
			for(utils.HibernateLogEntry entry : _list)
			{ 
				logindex++;
				if(longestThree.size() == 0) {
					longestThree.add(entry);
				}
				else if(longestThree.size() < 3) {
					longestThree.add(entry);
					for(int i = longestThree.size() - 2; i >= 0; i--) {
						if(longestThree.get(i).durationExclusive < entry.durationExclusive) {
							longestThree.set(i + 1, longestThree.get(i));
							longestThree.set(i, entry);
						}
					}
				}
				else if(longestThree.get(longestThree.size() - 1).durationExclusive < entry.durationExclusive) {
					longestThree.set(longestThree.size() - 1, entry);
					for(int i = longestThree.size() - 2; i >= 0; i--) {
						if(longestThree.get(i).durationExclusive < entry.durationExclusive) {
							longestThree.set(i + 1, longestThree.get(i));
							longestThree.set(i, entry);
						}
					}
				}
			}
			sout.print("<p>SQLs = <span id=\"sqllogcount\">" + _list.size() + "</span>, Time = <span id=\"sqllogtime\">" + _totalTime + " ms</span>");
			boolean printedSessionContext = false;
			if(session != null && session instanceof org.hibernate.engine.SessionImplementor) {
				org.hibernate.engine.PersistenceContext context = ((org.hibernate.engine.SessionImplementor)session).getPersistenceContext();
				if(context != null) {
					Map entityEntries = context.getEntityEntries();
					Map collectionEntries = context.getCollectionEntries();
					SortedMap<String, Integer> entCounter = new TreeMap<String, Integer>();
					SortedMap<String, Integer> colCounter = new TreeMap<String, Integer>();
					if(entityEntries != null && collectionEntries != null) {
						sout.print(", Entities = <span id=\"sqllogentities\">" + entityEntries.size() + "</span>, Collections = <span id=\"sqllogcollections\">" + collectionEntries.size() + "</span></p>");

						// Count entities in the hibernate session by classname
						for(Object ent : entityEntries.values()) {
							if(ent instanceof org.hibernate.engine.EntityEntry) {
								String name = ((org.hibernate.engine.EntityEntry)ent).getEntityName();
								if(name.indexOf("webdsl.generated.domain.") == 0) name = name.substring("webdsl.generated.domain.".length());
								Integer count = entCounter.get(name);
								if(count == null) count = new Integer(0);
								entCounter.put(name, count + 1);
							}
						}

						// Count collections in the hibernate session by their role
						for(Object col : collectionEntries.values()) {
							if(col instanceof org.hibernate.engine.CollectionEntry) {
								org.hibernate.persister.collection.CollectionPersister persister = ((org.hibernate.engine.CollectionEntry)col).getLoadedPersister();
								if(persister == null) persister = ((org.hibernate.engine.CollectionEntry)col).getCurrentPersister();
								if(persister != null) {
									String name = persister.getRole();
									if(name.indexOf("webdsl.generated.domain.") == 0) name = name.substring("webdsl.generated.domain.".length());
									Integer count = colCounter.get(name);
									if(count == null) count = new Integer(0);
									colCounter.put(name, count + 1);
								}
							}
						}

						sout.print("<table class=\"sqllogdetails\"><tr><th class=\"sqllogdetailsname\">Entity/Collection</th><th class=\"sqllogdetailsinstances\">Instances</th></tr>");
						java.util.Iterator<String> entKeys = entCounter.keySet().iterator(); 
						java.util.Iterator<String> colKeys = colCounter.keySet().iterator();
						String entKey = entKeys.hasNext() ? entKeys.next() : null;
						String colKey = colKeys.hasNext() ? colKeys.next() : null;
						while(entKey != null || colKey != null) {
							if(colKey != null && (entKey == null || entKey.compareTo(colKey) > 0)) {
								sout.print("<tr class=\"sqllogdetailscollection\"><td class=\"sqllogdetailsname\">");
								sout.print(colKey);
								sout.print("</td><td class=\"sqllogdetailsinstances\" id=\"sqllogcollection_" + colKey.replace('.', '_') + "\">");
								sout.print(colCounter.get(colKey));
								sout.print("</td></tr>");
								colKey = colKeys.hasNext() ? colKeys.next() : null;
							} else {
								sout.print("<tr class=\"sqllogdetailsentity\"><td class=\"sqllogdetailsname\">");
								sout.print(entKey);
								sout.print("</td><td class=\"sqllogdetailsinstances\" id=\"sqllogentity_" + entKey.replace('.', '_') + "\">");
								sout.print(entCounter.get(entKey));
								sout.print("</td></tr>");
								entKey = entKeys.hasNext() ? entKeys.next() : null;
							}
						}
						sout.print("</table>");
						printedSessionContext = true;
					}
				}
			}
			if(!printedSessionContext) {
				sout.print(", Entities = <span id=\"sqllogentities\">?</span>, Collections = <span id=\"sqllogcollections\">?</span></p>");
			}
			logindex = 0;
			for(utils.HibernateLogEntry entry : _list)
			{
				sout.print("<div class=\"sqllog\">Query " + (++logindex) + " (" + entry.durationExclusive + " ms):<br /><pre>" + utils.HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
			sout.print("<p><b>The three queries that took the most time:</b></p><table class=\"sqllog\">");
			for(int i = 0; i < longestThree.size(); i++)
			{
				utils.HibernateLogEntry entry = longestThree.get(i);
				sout.print("<div class=\"sqllog\">");
				if(i == 0) sout.print("Longest query (");
				if(i == 1) sout.print("Second longest query (");
				if(i == 2) sout.print("Third longest query (");
				sout.print(entry.durationExclusive + " ms):<br /><pre>" + utils.HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
		}
		catch(Exception ex) {
			sout.print("<pre class=\"sqllogexception\">" + utils.HTMLFilter.filter(ex.toString()) + "</pre>");
		}
	}

	public int getSQLCount() {
		if(_list == null) return 0;
		return _list.size();
	}

	public long getTotalTime() {
		return _totalTime;
	}
	
    public static long dateDiff(Date start, Date end) {
    	Calendar calendar = Calendar.getInstance();
    	calendar.setTime(start);
    	long startTime = calendar.getTimeInMillis();
    	calendar.setTime(end);
    	long endTime = calendar.getTimeInMillis();
    	return endTime - startTime;
    }
}

class HibernateLogEntry {
	public Date openTime = null;
	public Date closeTime = null;
	public long durationInclusive = 0;
	public long durationExclusive = 0;
	public int subEntries = 0;
	public String sql = null;
	public List<String> parameterVals = new ArrayList<String>();
	public List<String> parameterTypes = new ArrayList<String>();

	public String getSQL() {
		if(sql == null) return null;

		java.util.StringTokenizer tokens = new java.util.StringTokenizer(sql, "/*'\"?", true);
		StringBuilder sb = new StringBuilder();
		String token = null;
		String previous = null;
		int index = 0;
		while(tokens.hasMoreTokens()) {
			previous = token;
			token = tokens.nextToken();
			if ( "'".equals( token ) ) {
				do {
					sb.append(token);
					token = tokens.nextToken();
				}
				while ( !"'".equals( token ) && tokens.hasMoreTokens() ); // cannot handle single quotes
				previous = token;
				sb.append(token);
			}
			else if ( "\"".equals( token ) ) {
				do {
					sb.append(token);
					token = tokens.nextToken();
				}
				while ( !"\"".equals( token ) );
				previous = token;
				sb.append(token);
			}
			else if ( "/".equals(previous) && "*".equals( token ) ) {
				do {
					sb.append(token);
					previous = token;
					token = tokens.nextToken();
				}
				while ( !("*".equals( previous ) && "/".equals( token )) );
				previous = token;
				sb.append(token);
			}
			else if ( "?".equals( token ) ) {
				if(index < parameterVals.size()) {
					sb.append(parameterVals.get(index++));
				}
				else {
					sb.append(token);
				}
			}
			else {
				sb.append(token);
			}
		}
		return sb.toString();
	}
}
