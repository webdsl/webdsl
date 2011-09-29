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
	protected Date _firstQueryStart = null;
	protected HibernateLogEntry _lastQuery = null;
	protected String _error = null;

	public static void printHibernateLog(PrintWriter sout, utils.AbstractPageServlet page) {
		RequestAppender requestAppender = RequestAppender.getNamed("hibernateLog");
		if(requestAppender != null) { 
			String log = requestAppender.getLog();
			HibernateLog hibLog = new HibernateLog();
			if(hibLog.tryParse(log)) {
				hibLog.print(sout, page);
			}
			else {
				hibLog.print(sout, page);
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
        Stack<HibernateLogEntry> entries = new Stack<HibernateLogEntry>();
        HibernateLogEntry current = null;
        while((line = rdr.readLine()) != null) {
        	linenr++;
        	int sep1 = line.indexOf("|");
        	int sep2 = line.indexOf("|", sep1 + 1);
        	int sep3 = line.indexOf("|", sep2 + 1);
        	if(sep1 < 0 || sep2 < 0 || sep3 < 0) throw new ParseException("Incorrect layout pattern detected", linenr);
        	String cat = line.substring(0, sep1);
        	String time = line.substring(sep1 + 1, sep2);
        	String template = line.substring(sep2 + 1, sep3);
        	String msg = line.substring(sep3 + 1);
        	if(cat.indexOf("org.hibernate.jdbc") == 0) {
        		if(msg.indexOf("about to open PreparedStatement") == 0) {
        			if(current != null) entries.push(current);
        			current = new HibernateLogEntry();
        			current.openTime = absoluteFormat.parse(time);
        			current.template = template;
        			if(_firstQueryStart == null) {
        				_firstQueryStart = current.openTime; 
        			}
        			_list.add(current);
        		}
        		else if(msg.indexOf("about to close PreparedStatement") == 0) {
        			if(current == null) throw new ParseException("No statement to close", linenr);
        			current.closeTime = absoluteFormat.parse(time);
        			_lastQuery = current;  
        			current.duration = dateDiff(current.openTime, current.closeTime);
        			if(entries.empty()) {
        				current = null;
        			}
        			else {
        				HibernateLogEntry next = entries.pop();
        				current.subEntries = next.subEntries + 1;
        				current = next;
        			}
        		}
        	}
        	if(cat.indexOf("org.hibernate.stat") == 0 && msg.indexOf("HQL: ") == 0) {
        		if(current == null && _lastQuery != null) {
            		int timeidx = msg.lastIndexOf("time: ");
            		int rowidx = msg.lastIndexOf("ms, rows: ");
            		_lastQuery.duration = Integer.parseInt(msg.substring(timeidx + 6, rowidx));
        			_lastQuery.closeTime = dateAdd(_lastQuery.openTime, _lastQuery.duration);
        			_lastQuery.rows = Integer.parseInt(msg.substring(rowidx + 10));
        		}
        	}
        	if(cat.indexOf("org.hibernate.loader") == 0) {
        		int idx = msg.indexOf("total objects hydrated: ");
        		if(current == null && _lastQuery != null && idx == 0) {
        			_lastQuery.hydrated = Integer.parseInt(msg.substring(24));
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

	public void print(PrintWriter sout, utils.AbstractPageServlet page) {
		long time = page.getElapsedTime();
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
						if(longestThree.get(i).duration < entry.duration) {
							longestThree.set(i + 1, longestThree.get(i));
							longestThree.set(i, entry);
						}
					}
				}
				else if(longestThree.get(longestThree.size() - 1).duration < entry.duration) {
					longestThree.set(longestThree.size() - 1, entry);
					for(int i = longestThree.size() - 2; i >= 0; i--) {
						if(longestThree.get(i).duration < entry.duration) {
							longestThree.set(i + 1, longestThree.get(i));
							longestThree.set(i, entry);
						}
					}
				}
			}
			sout.print("<p>SQLs = <span id=\"sqllogcount\">" + _list.size() + "</span>, Time = <span id=\"sqllogtime\">" + time + " ms</span>");
			boolean printedSessionContext = false;
			org.hibernate.Session session = page.getHibSession();
			if(session != null && session instanceof org.hibernate.engine.SessionImplementor) {
				org.hibernate.engine.PersistenceContext context = ((org.hibernate.engine.SessionImplementor)session).getPersistenceContext();
				if(context != null) {
					Map entityEntries = context.getEntityEntries();
					Map collectionEntries = context.getCollectionEntries();
					int entities = 0;
					int collections = 0;
					SortedMap<String, Integer> entCounter = new TreeMap<String, Integer>();
					SortedMap<String, Integer> colCounter = new TreeMap<String, Integer>();
					if(entityEntries != null && collectionEntries != null) {
						// Count entities in the hibernate session by classname
						for(Object ent : entityEntries.values()) {
							if(ent instanceof org.hibernate.engine.EntityEntry) {
								org.hibernate.engine.EntityEntry entEntry = (org.hibernate.engine.EntityEntry)ent;
								String name = entEntry.getEntityName();
								if(name.indexOf("webdsl.generated.domain.") == 0) name = name.substring("webdsl.generated.domain.".length());
								Integer count = entCounter.get(name);
								if(count == null) count = new Integer(0);
								if(org.hibernate.Hibernate.isInitialized(context.getProxy(entEntry.getEntityKey()))) {
									count++;
									entities++;
								}
								entCounter.put(name, count);
							}
						}

						// Count collections in the hibernate session by their role
						for(Object col : collectionEntries.values()) {
							if(col instanceof org.hibernate.engine.CollectionEntry) {
								org.hibernate.engine.CollectionEntry colEntry = (org.hibernate.engine.CollectionEntry)col;
								org.hibernate.persister.collection.CollectionPersister persister = colEntry.getLoadedPersister();
								if(persister != null) {
									String name = persister.getRole();
									if(name.indexOf("webdsl.generated.domain.") == 0) name = name.substring("webdsl.generated.domain.".length());
									Integer count = colCounter.get(name);
									if(count == null) count = new Integer(0);
									org.hibernate.engine.CollectionKey collectionKey = new org.hibernate.engine.CollectionKey( persister, colEntry.getLoadedKey(), ((org.hibernate.engine.SessionImplementor)session).getEntityMode() );
									if(context.getCollection(collectionKey).wasInitialized()) {
										count++;
										collections++;
									}
									colCounter.put(name, count);
								}
							}
						}

						sout.print(", Entities = <span id=\"sqllogentities\">" + entities+ "</span>, Collections = <span id=\"sqllogcollections\">" + collections + "</span></p>");
						sout.print("<table class=\"sqllogdetails\"><tr><th class=\"sqllogdetailsname\">Entity/Collection</th><th class=\"sqllogdetailsinstances\">Instances</th></tr>");
						java.util.Iterator<String> entKeys = entCounter.keySet().iterator(); 
						java.util.Iterator<String> colKeys = colCounter.keySet().iterator();
						String entKey = entKeys.hasNext() ? entKeys.next() : null;
						String colKey = colKeys.hasNext() ? colKeys.next() : null;
						while(entKey != null || colKey != null) {
							if(colKey != null && (entKey == null || entKey.compareTo(colKey) > 0)) {
								if(colCounter.get(colKey) > 0) {
									sout.print("<tr class=\"sqllogdetailscollection\"><td class=\"sqllogdetailsname\">");
									sout.print(colKey);
									sout.print("</td><td class=\"sqllogdetailsinstances\" id=\"sqllogcollection_" + colKey.replace('.', '_') + "\">");
									sout.print(colCounter.get(colKey));
									sout.print("</td></tr>");
								}
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
				sout.print("<div class=\"sqllog\">Query " + (++logindex) + ": time=" + entry.duration + "ms");
				if(entry.rows > -1) sout.print(", rows=" + entry.rows);
				if(entry.hydrated > -1) sout.print(", hydrated=" + entry.hydrated);
				sout.print(", template=" + entry.template);
				sout.print("<br /><pre>" + utils.HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
			sout.print("<p><b>The three queries that took the most time:</b></p><table class=\"sqllog\">");
			for(int i = 0; i < longestThree.size(); i++)
			{
				utils.HibernateLogEntry entry = longestThree.get(i);
				sout.print("<div class=\"sqllog\">");
				if(i == 0) sout.print("Longest query: ");
				if(i == 1) sout.print("Second longest query: ");
				if(i == 2) sout.print("Third longest query: ");
				sout.print("time=" + entry.duration + "ms");
				if(entry.rows > -1) sout.print(", rows=" + entry.rows);
				if(entry.hydrated > -1) sout.print(", hydrated=" + entry.hydrated);
				sout.print(", template=" + entry.template);
				sout.print("<br /><pre>" + utils.HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
		}
		catch(Exception ex) {
			ex.printStackTrace();
			sout.print("<pre class=\"sqllogexception\">" + utils.HTMLFilter.filter(ex.toString()) + "</pre>");
		}
	}

	public int getSQLCount() {
		if(_list == null) return 0;
		return _list.size();
	}

	public long getTotalTimespan() {
		if(_firstQueryStart == null || _lastQuery == null) return 0;
		return dateDiff(_firstQueryStart, _lastQuery.closeTime);
	}
	
    public static Date dateAdd(Date start, long ms) {
    	Calendar calendar = Calendar.getInstance();
    	calendar.setTime(start);
    	long newTime = calendar.getTimeInMillis() + ms;
    	calendar.setTimeInMillis(newTime);
    	return calendar.getTime();
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
	public long duration = -1;
	public int rows = -1;
	public int hydrated = -1;
	public int subEntries = 0;
	public String sql = null;
	public String template = null;
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
