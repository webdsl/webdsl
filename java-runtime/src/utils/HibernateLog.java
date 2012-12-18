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
import java.util.HashMap;
import java.util.Stack;

public class HibernateLog {
	protected List<HibernateLogEntry> _list = null;
	protected Date _firstQueryStart = null;
	protected HibernateLogEntry _lastQuery = null;
	protected String _error = null;
	protected List<String> _fetched = null;
	protected int _entities = 0;
	protected int _duplicates = 0;
	protected int _collections = 0;
	protected SortedMap<String, Integer> _entityCounter = null;
	protected Map<String, Integer> _duplicateCounter = null;
	protected SortedMap<String, Integer> _collectionCounter = null;

	public static void printHibernateLog(PrintWriter sout, utils.AbstractPageServlet page, String source) {
		RequestAppender requestAppender = RequestAppender.getInstance();
		if(requestAppender != null) { 
			String log = requestAppender.getLog();
			HibernateLog hibLog = new HibernateLog();
			if(hibLog.tryParse(log, HibernateUtil.getCurrentSession())) {
				hibLog.print(sout, page, source);
			}
			else {
				hibLog.print(sout, page, source);
				sout.print("<pre>" + utils.HTMLFilter.filter(log) + "</pre>");
			}
		}
	}

	public static String printHibernateLog(utils.AbstractPageServlet page, String source) {
	    java.io.StringWriter s = new java.io.StringWriter();
	    java.io.PrintWriter out = new java.io.PrintWriter(s);
	    printHibernateLog(out, page, source);
	    return s.toString();
	}

	public static void printHibernateLogJson(PrintWriter sout, utils.AbstractPageServlet page, String source) {
		RequestAppender requestAppender = RequestAppender.getInstance();
		if(requestAppender != null) { 
			String log = requestAppender.getLog();
			HibernateLog hibLog = new HibernateLog();
			hibLog.tryParse(log, HibernateUtil.getCurrentSession());
			hibLog.printJson(sout, page, source);
		}
	}

	public static String printHibernateLogJson(utils.AbstractPageServlet page, String source) {
	    java.io.StringWriter s = new java.io.StringWriter();
	    java.io.PrintWriter out = new java.io.PrintWriter(s);
	    printHibernateLogJson(out, page, source);
	    return s.toString();
	}

	public HibernateLog() {
		
	}

	public boolean tryParse(String str, org.hibernate.Session session) {
		return tryParse(new BufferedReader(new StringReader(str)), session);
    }

    public boolean tryParse(InputStream in, org.hibernate.Session session) {
    	return tryParse(new BufferedReader(new InputStreamReader(in)), session);
    }

    public boolean tryParse(BufferedReader rdr, org.hibernate.Session session) {
		try {
			parse(rdr, session);
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

	public void parse(String str, org.hibernate.Session session) throws IOException, ParseException {
        parse(new BufferedReader(new StringReader(str)), session);
    }

    public void parse(InputStream in, org.hibernate.Session session) throws IOException, ParseException {
        parse(new BufferedReader(new InputStreamReader(in)), session);
    }

    public void parse(BufferedReader rdr, org.hibernate.Session session) throws IOException, ParseException {
        SimpleDateFormat absoluteFormat = new SimpleDateFormat("HH:mm:ss,SSS");
        org.hibernate.jdbc.util.BasicFormatterImpl sqlFormat = new org.hibernate.jdbc.util.BasicFormatterImpl();
        String line;
        int linenr = 0;
        _list = new ArrayList<HibernateLogEntry>();
        Stack<HibernateLogEntry> entries = new Stack<HibernateLogEntry>();
        HibernateLogEntry current = null;
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("([a-zA-Z0-9.]+)#([a-fA-F0-9-]+)");
        _fetched = new ArrayList<String>();
        _duplicates = 0;
        _duplicateCounter = new HashMap<String, Integer>();
        _entities = 0;
        _entityCounter = null;
        _collections = 0;
        _collectionCounter = null;
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
        		else if(msg.indexOf("reusing prepared statement") == 0) {
        			if(current == null) throw new ParseException("No statement to reuse", linenr);
        			current.closeTime = absoluteFormat.parse(time);
        			current.duration = dateDiff(current.openTime, current.closeTime);
        			_lastQuery = current;  
        			if(!entries.empty()) {
        				current = entries.peek();
        				current.subEntries += _lastQuery.subEntries + 1;
        			}
        			current = new HibernateLogEntry();
        			//current.sql = _lastQuery.sql;
        			current.openTime = _lastQuery.closeTime;
        			current.template = template;
        			_list.add(current);
        		}
        		else if(msg.indexOf("about to close PreparedStatement") == 0) {
        			if(current == null) throw new ParseException("No statement to close", linenr);
        			current.closeTime = absoluteFormat.parse(time);
        			current.duration = dateDiff(current.openTime, current.closeTime);
        			_lastQuery = current;
        			if(entries.empty()) {
        				current = null;
        			}
        			else {
        				current = entries.pop();
        				current.subEntries += _lastQuery.subEntries + 1;
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
        		if(current == null && _lastQuery != null && msg.indexOf("total objects hydrated: ") == 0) {
        			_lastQuery.hydrated = Integer.parseInt(msg.substring(24));
        		}
        		else if(msg.indexOf("result row:") == 0) {
        			java.util.regex.Matcher matcher = pattern.matcher(msg);
        			//String match;
        			String ent;
        			String entId;
        			while (matcher.find()) {
        				//match = matcher.group(0);
    					ent = matcher.group(1);
    					entId = matcher.group(2);
    					Object obj = null;
    					try{
    						obj = session.load(ent, java.util.UUID.fromString(entId));
    					} catch(Exception e) {
    					}
    					// If load returned an uninitialized proxy then we set it to null, so that we do not use it (to prevent initialization)
    					// However, load should never return an uninitialized proxy, because we are looking at entities that should have been hydrated
    					if(obj instanceof org.hibernate.proxy.HibernateProxy && ((org.hibernate.proxy.HibernateProxy)obj).getHibernateLazyInitializer().isUninitialized()) obj = null;
    					if(obj instanceof org.webdsl.WebDSLEntity) {
    						ent = ((org.webdsl.WebDSLEntity)obj).get_WebDslEntityType(); // This returns the correct sub-entity
    					}
    					else {
    						// This only happens if entId is not a UUID, load threw an exception or returned an uninitialized proxy.
    						// We record it with the type shown inside the EntityKey, but the real sub-type is unknown
    						if(ent.indexOf("webdsl.generated.domain.") == 0) ent = ent.substring("webdsl.generated.domain.".length());
    						ent = ent + " (subtype uknown)";
    					}
        				if(_fetched.contains(ent+"#"+entId)) {
        					_duplicates++;
        					if(current != null) current.duplicates++;
        					if(_duplicateCounter.containsKey(ent)) {
        						_duplicateCounter.put(ent, _duplicateCounter.get(ent) + 1);
        					}
        					else {
        						_duplicateCounter.put(ent, 1);
        					}
        				}
        				else {
        					_fetched.add(ent+"#"+entId);
        				}
        			}
    			}
        	}
        	else if(cat.indexOf("org.hibernate.SQL") == 0) {
        		if(current == null || current.sql != null) throw new ParseException("Statement was not expected", linenr);
       			current.sql = sqlFormat.format(msg).replaceAll("^\n", "");
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
        parseSessionCache(session);
    }

	public void print(PrintWriter sout, utils.AbstractPageServlet page, String source) {
		long time = page.getElapsedTime();
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
			sout.print("<p>");
			if(!(source == null || source.isEmpty())) {
				sout.print("(");
				sout.print(source);
				sout.print(") ");
			}
			sout.print("<a name=\"logsql\"></a>SQLs = <span id=\"sqllogcount\">" + _list.size() + "</span>, Time = <span id=\"sqllogtime\">" + time + " ms</span>");
			if(_entityCounter != null && _collectionCounter != null) {
				sout.print(", Entities = <span id=\"sqllogentities\">" + _entities + "</span>, Duplicates = <span id=\"sqllogduplicates\">" + _duplicates + "</span>, Collections = <span id=\"sqllogcollections\">" + _collections + "</span></p>");
				sout.print("<table class=\"sqllogdetails\"><tr><th class=\"sqllogdetailsname\">Entity/Collection</th><th class=\"sqllogdetailsinstances\">Instances</th><th class=\"sqllogdetailsduplicates\">Duplicates</th></tr>");
				java.util.Iterator<String> entKeys = _entityCounter.keySet().iterator(); 
				java.util.Iterator<String> colKeys = _collectionCounter.keySet().iterator();
				String entKey = entKeys.hasNext() ? entKeys.next() : null;
				String colKey = colKeys.hasNext() ? colKeys.next() : null;
				while(entKey != null || colKey != null) {
					if(colKey != null && (entKey == null || entKey.compareTo(colKey) > 0)) {
						if(_collectionCounter.get(colKey) > 0) {
							sout.print("<tr class=\"sqllogdetailscollection\"><td class=\"sqllogdetailsname\">");
							sout.print(colKey);
							sout.print("</td><td class=\"sqllogdetailsinstances\" id=\"sqllogcollection_" + colKey.replace('.', '_') + "\">");
							sout.print(_collectionCounter.get(colKey));
							sout.print("</td><td class=\"sqllogdetailsduplicates\" id=\"sqllogduplicates_" + colKey.replace('.', '_') + "\">");
							sout.print("</td></tr>");
						}
						colKey = colKeys.hasNext() ? colKeys.next() : null;
					} else {
						sout.print("<tr class=\"sqllogdetailsentity\"><td class=\"sqllogdetailsname\">");
						sout.print(entKey);
						sout.print("</td><td class=\"sqllogdetailsinstances\" id=\"sqllogentity_" + entKey.replace('.', '_') + "\">");
						sout.print(_entityCounter.get(entKey));
						sout.print("</td><td class=\"sqllogdetailsduplicates\" id=\"sqllogduplicates_" + entKey.replace('.', '_') + "\">");
						if(_duplicateCounter.containsKey(entKey)) {
							sout.print(_duplicateCounter.get(entKey));
							_duplicateCounter.remove(entKey);
						}
						else {
							sout.print("0");
						}
						sout.print("</td></tr>");
						entKey = entKeys.hasNext() ? entKeys.next() : null;
					}
				}
				for(String key : _duplicateCounter.keySet()) {
					sout.print("<tr class=\"sqllogdetailsduplicate\"><td class=\"sqllogdetailsname\">");
					sout.print(key);
					sout.print("</td><td class=\"sqllogdetailsinstances\"></td><td class=\"sqllogdetailsduplicates\" id=\"sqllogduplicates_" + key.replace('.', '_') + "\">");
					sout.print(_duplicateCounter.get(key));
					sout.print("</td></tr>");
				}
				sout.print("</table>");
			}
			else {
				sout.print(", Entities = <span id=\"sqllogentities\">?</span>, Duplicates = <span id=\"sqllogduplicates\">?</span>, Collections = <span id=\"sqllogcollections\">?</span></p>");
			}
			logindex = 0;
			for(utils.HibernateLogEntry entry : _list)
			{
				sout.print("<div class=\"sqllog\">Query " + (++logindex) + ": time=" + entry.duration + "ms");
				if(entry.rows > -1) sout.print(", rows=" + entry.rows);
				if(entry.hydrated > -1) sout.print(", hydrated=" + entry.hydrated);
				if(entry.duplicates > 0) sout.print(", duplicates=" + entry.duplicates);
				sout.print(", template=" + entry.template);
				sout.print("<br /><pre>" + utils.HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
			sout.print("<p><b>The three queries that took the most time:</b></p>");
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
				if(entry.duplicates > 0) sout.print(", duplicates=" + entry.duplicates);
				sout.print(", template=" + entry.template);
				sout.print("<br /><pre>" + utils.HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
		}
		catch(Exception ex) {
			org.webdsl.logging.Logger.error("EXCEPTION",ex);
			sout.print("<pre class=\"sqllogexception\">" + utils.HTMLFilter.filter(ex.toString()) + "</pre>");
		}
	}

	public void printJson(PrintWriter sout, utils.AbstractPageServlet page, String source) {
		sout.print("{ action: \"logsqljson\"");
		if(!(source == null || source.isEmpty())) {
			sout.print(", source: \"");
			sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(source));
			sout.print("\"");
		}
		if(_error != null) {
			sout.print(", error: \"");
			sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(_error));
			sout.print("\"}");
			return;
		}
		try {
			int logindex = 0;
			long time = page.getElapsedTime();
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
			sout.print(",sqls: ");
			sout.print(_list.size());
			sout.print(",time: ");
			sout.print(time);
			if(_entityCounter != null && _collectionCounter != null) {
				sout.print(",entities: ");
				sout.print(_entities);
				sout.print(",duplicates: ");
				sout.print(_duplicates);
				sout.print(",collections: ");
				sout.print(_collections);
				sout.print(",details: [");
				java.util.Iterator<String> entKeys = _entityCounter.keySet().iterator(); 
				java.util.Iterator<String> colKeys = _collectionCounter.keySet().iterator();
				String entKey = entKeys.hasNext() ? entKeys.next() : null;
				String colKey = colKeys.hasNext() ? colKeys.next() : null;
				boolean first = true;
				while(entKey != null || colKey != null) {
					if(colKey != null && (entKey == null || entKey.compareTo(colKey) > 0)) {
						if(_collectionCounter.get(colKey) > 0) {
							if(!first) sout.print(",");
							if(first) first = false;
							sout.print("{type: 0,name:\"");
							sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(colKey));
							sout.print("\",count: ");
							sout.print(_collectionCounter.get(colKey));
							sout.print("}");
						}
						colKey = colKeys.hasNext() ? colKeys.next() : null;
					} else {
						if(!first) sout.print(",");
						if(first) first = false;
						sout.print("{type: 1,name:\"");
						sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(entKey));
						sout.print("\",count: ");
						sout.print(_entityCounter.get(entKey));
						if(_duplicateCounter.containsKey(entKey)) {
							sout.print(",duplicates: ");
							sout.print(_duplicateCounter.get(entKey));
							_duplicateCounter.remove(entKey);
						}
						sout.print("}");
						entKey = entKeys.hasNext() ? entKeys.next() : null;
					}
				}
				for(String key : _duplicateCounter.keySet()) {
					if(!first) sout.print(",");
					if(first) first = false;
					sout.print("{type: 2,name:\"");
					sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(key));
					sout.print("\",duplicates: ");
					sout.print(_duplicateCounter.get(key));
					sout.print("}");
				}
				sout.print("]");
			}
			sout.print(",entries: [");
			logindex = 0;
			boolean first = true;
			for(utils.HibernateLogEntry entry : _list)
			{
				if(!first) sout.print(",");
				if(first) first = false;
				printEntryJson(sout, entry);
			}
			sout.print("], longest: [");
			for(int i = 0; i < longestThree.size(); i++)
			{
				if(i > 0) sout.print(",");
				utils.HibernateLogEntry entry = longestThree.get(i);
				printEntryJson(sout, entry);
			}
			sout.print("]");
		}
		catch(Exception ex) {
			org.webdsl.logging.Logger.error("EXCEPTION",ex);
			sout.print(", error: \"");
			sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ex.toString()));
		}
		finally {
			sout.print("}");
		}
	}

	protected void printEntryJson(PrintWriter sout, utils.HibernateLogEntry entry) {
		sout.print("{duration: ");
		sout.print(entry.duration);
		if(entry.rows > -1) {
			sout.print(", rows: ");
			sout.print(entry.rows);
		}
		if(entry.hydrated > -1) {
			sout.print(", hydrated: ");
			sout.print(entry.hydrated);
		}
		if(entry.duplicates > 0) {
			sout.print(", duplicates: ");
			sout.print(entry.duplicates);
		}
		sout.print(", template: \"");
		sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(entry.template));
		sout.print("\", sql: \"");
		sout.print(org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(entry.getSQL()));
		sout.print("\"}");
	}

	public void parseSessionCache(org.hibernate.Session session) {
		if(session != null && session instanceof org.hibernate.engine.SessionImplementor) {
			org.hibernate.engine.PersistenceContext context = ((org.hibernate.engine.SessionImplementor)session).getPersistenceContext();
			if(context != null) {
				Map entityEntries = context.getEntityEntries();
				Map collectionEntries = context.getCollectionEntries();
				_entities = 0;
				_collections = 0;
				_entityCounter = new TreeMap<String, Integer>();
				_collectionCounter = new TreeMap<String, Integer>();
				if(entityEntries != null && collectionEntries != null) {
					// Count entities in the hibernate session by classname
					for(Object ent : entityEntries.values()) {
						if(ent instanceof org.hibernate.engine.EntityEntry) {
							org.hibernate.engine.EntityEntry entEntry = (org.hibernate.engine.EntityEntry)ent;
							String name = entEntry.getEntityName();
							if(name.indexOf("webdsl.generated.domain.") == 0) name = name.substring("webdsl.generated.domain.".length());
							Integer count = _entityCounter.get(name);
							if(count == null) count = new Integer(0);
							count++;
							_entities++;
							_entityCounter.put(name, count);
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
								Integer count = _collectionCounter.get(name);
								if(count == null) count = new Integer(0);
								org.hibernate.engine.CollectionKey collectionKey = new org.hibernate.engine.CollectionKey( persister, colEntry.getLoadedKey(), ((org.hibernate.engine.SessionImplementor)session).getEntityMode() );
								if(context.getCollection(collectionKey).wasInitialized()) {
									count++;
									_collections++;
								}
								_collectionCounter.put(name, count);
							}
						}
					}
				}
			}
		}
	}

	public String getError() {
		return _error;
	}

	public int getSQLCount() {
		if(_list == null) return 0;
		return _list.size();
	}

	public int getEntityCount() {
		return _entities;
	}

	public int getDuplicateCount() {
		return _duplicates;
	}

	public int getCollectionCount() {
		return _collections;
	}

	public java.util.Set<String> getEntities() {
		java.util.Set<String> rtn = new java.util.HashSet<String>();
		if(_entityCounter != null) {
			rtn.addAll(_entityCounter.keySet());
		}
		return rtn;
	}

	public int getEntityCount(String entity) {
		if(_entityCounter == null) return -1;
		if(!_entityCounter.containsKey(entity)) return 0;
		return _entityCounter.get(entity);
	}

	public int getDuplicateCount(String entity) {
		if(_duplicateCounter == null) return -1;
		if(!_duplicateCounter.containsKey(entity)) return 0;
		return _duplicateCounter.get(entity);
	}

	public int getCollectionCount(String role) {
		if(_collectionCounter == null) return -1;
		if(!_collectionCounter.containsKey(role)) return 0;
		return _collectionCounter.get(role);
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
	public int duplicates = 0;
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
