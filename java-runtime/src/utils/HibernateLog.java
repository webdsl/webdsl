package utils;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.Stack;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.core.LogEvent;
import org.hibernate.engine.CollectionEntry;
import org.hibernate.engine.CollectionKey;
import org.hibernate.engine.EntityEntry;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.jdbc.util.BasicFormatterImpl;
import org.hibernate.proxy.HibernateProxy;
import org.webdsl.WebDSLEntity;

public class HibernateLog {
	protected static final BasicFormatterImpl sqlFormat = new BasicFormatterImpl();
	protected static final Pattern pattern = Pattern.compile("([a-zA-Z0-9.]+)#([a-fA-F0-9-]+)");

	protected List<HibernateLogEntry> _list = null;
	protected Date _firstQueryStart = null;
	protected HibernateLogEntry _lastQuery = null;
	protected String _error = null;
	protected HashSet<String> _fetched = null;
	protected int _entities = 0;
	protected int _duplicates = 0;
	protected int _collections = 0;
	protected SortedMap<String, Integer> _entityCounter = null;
	protected Map<String, Integer> _duplicateCounter = null;
	protected SortedMap<String, Integer> _collectionCounter = null;
	protected Stack<HibernateLogEntry> _entries = new Stack<HibernateLogEntry>();
	protected HibernateLogEntry _current = null;
	protected List<HibernateLogEntityResult> _results = new ArrayList<HibernateLogEntityResult>();

	public static void printHibernateLog(PrintWriter sout, AbstractPageServlet page, String source) {
		RequestAppender requestAppender = RequestAppender.getInstance();
		if(requestAppender != null) {
			utils.HibernateLog log = requestAppender.getLog();
			log.parseSessionCache(HibernateUtil.getCurrentSession());
			log.print(sout, page, source);
		}
	}

	public static String printHibernateLog(AbstractPageServlet page, String source) {
		StringWriter s = new StringWriter();
		PrintWriter out = new PrintWriter(s);
		printHibernateLog(out, page, source);
		return s.toString();
	}

	public HibernateLog() {
		_list = new ArrayList<HibernateLogEntry>();
		_fetched = new HashSet<String>();
		_duplicates = 0;
		_duplicateCounter = new HashMap<String, Integer>();
		_entities = 0;
		_entityCounter = null;
		_collections = 0;
		_collectionCounter = null;
	}

	public void append(LogEvent event) {
		if(_error != null) return;
		try {
			String cat = event.getLoggerName();
			String template = event.getContextData().getValue("template").toString();
			String msg = event.getMessage().toString();
			if(cat.indexOf("org.hibernate.jdbc") == 0) {
				if(msg.indexOf("about to open PreparedStatement") == 0) {
					if(_current != null) _entries.push(_current);
					_current = new HibernateLogEntry();
					_current.openTime = new Date(event.getTimeMillis());
					_current.template = template;
					if(_firstQueryStart == null) {
						_firstQueryStart = _current.openTime;
					}
					_list.add(_current);
				}
				else if(msg.indexOf("reusing prepared statement") == 0) {
					if(_current == null) {
						_error = "No statement to reuse";
						return;
					}
					_current.closeTime = new Date(event.getTimeMillis());
					_current.duration = dateDiff(_current.openTime, _current.closeTime);
					_lastQuery = _current;
					if(!_entries.empty()) {
						_current = _entries.peek();
						_current.subEntries += _lastQuery.subEntries + 1;
					}
					_current = new HibernateLogEntry();
					//current.sql = _lastQuery.sql;
					_current.openTime = _lastQuery.closeTime;
					_current.template = template;
					_list.add(_current);
				}
				else if(msg.indexOf("about to close PreparedStatement") == 0) {
					if(_current == null) {
						_error = "No statement to close";
						return;
					}
					_current.closeTime = new Date(event.getTimeMillis());
					_current.duration = dateDiff(_current.openTime, _current.closeTime);
					_lastQuery = _current;
					if(_entries.empty()) {
						_current = null;
					}
					else {
						_current = _entries.pop();
						_current.subEntries += _lastQuery.subEntries + 1;
					}
				}
			}
			if(cat.indexOf("org.hibernate.stat") == 0 && msg.indexOf("HQL: ") == 0) {
				if(_current == null && _lastQuery != null) {
					int timeidx = msg.lastIndexOf("time: ");
					int rowidx = msg.lastIndexOf("ms, rows: ");
					_lastQuery.duration = Integer.parseInt(msg.substring(timeidx + 6, rowidx));
					_lastQuery.closeTime = dateAdd(_lastQuery.openTime, _lastQuery.duration);
					_lastQuery.rows = Integer.parseInt(msg.substring(rowidx + 10));
				}
			}
			if(cat.indexOf("org.hibernate.loader") == 0) {
				if(_current == null && _lastQuery != null && msg.indexOf("total objects hydrated: ") == 0) {
					_lastQuery.hydrated = Integer.parseInt(msg.substring(24));
				}
				else if(msg.indexOf("result row:") == 0) {
					Matcher matcher = pattern.matcher(msg);
					String ent;
					String entId;
					while (matcher.find()) {
						ent = matcher.group(1);
						entId = matcher.group(2);
						if(_current == null) {
							_results.add(new HibernateLogEntityResult(ent, entId));
						} else {
							_current.results.add(new HibernateLogEntityResult(ent, entId));
						}
					}
				}
			}
			else if(cat.indexOf("org.hibernate.SQL") == 0) {
				if(_current == null || _current.sql != null) {
					_error = "Statement was not expected";
					return;
				}
				_current.sql = sqlFormat.format(msg).replaceAll("^\n", "");
			}
			else if(cat.indexOf("org.hibernate.type") == 0) {
				if(_current == null) return;
				if(msg.indexOf("binding parameter [") == 0) {
					int idx = msg.indexOf("] as [");
					if(idx <= 19) return;
					int index = Integer.parseInt(msg.substring(19,  idx));
					int idx2 = msg.indexOf("] - ", idx);
					String type = msg.substring(idx + 6, idx2);
					String value = msg.substring(idx2 + 4);
					if(type.equals("VARCHAR")) value = "'" + value + "'";
					while(_current.parameterVals.size() - 1 < index - 1)
					{
						_current.parameterVals.add("<null>");
						_current.parameterTypes.add("null");
					}
					_current.parameterVals.set(index - 1, value);
					_current.parameterTypes.set(index - 1, type);
				}
			}
		} catch (Exception ex){
			_error = ex.toString();
		}
	}

	public void print(PrintWriter sout, AbstractPageServlet page, String source) {
		long time = page.getElapsedTime();
		if(_error != null) {
			sout.print("<pre class=\"sqllogexception\">" + HTMLFilter.filter(_error) + "</pre>");
			return;
		}
		try {
			int logindex = 0;
			java.util.List<HibernateLogEntry> longestThree = new ArrayList<HibernateLogEntry>();
			for(HibernateLogEntry entry : _list)
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
			for(HibernateLogEntry entry : _list)
			{
				sout.print("<div class=\"sqllog\">Query " + (++logindex) + ": time=" + entry.duration + "ms");
				if(entry.rows > -1) sout.print(", rows=" + entry.rows);
				if(entry.hydrated > -1) sout.print(", hydrated=" + entry.hydrated);
				if(entry.duplicates > 0) sout.print(", duplicates=" + entry.duplicates);
				sout.print(", template=" + entry.template);
				sout.print("<br /><pre>" + HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
			sout.print("<p><b>The three queries that took the most time:</b></p>");
			for(int i = 0; i < longestThree.size(); i++)
			{
				HibernateLogEntry entry = longestThree.get(i);
				sout.print("<div class=\"sqllog\">");
				if(i == 0) sout.print("Longest query: ");
				if(i == 1) sout.print("Second longest query: ");
				if(i == 2) sout.print("Third longest query: ");
				sout.print("time=" + entry.duration + "ms");
				if(entry.rows > -1) sout.print(", rows=" + entry.rows);
				if(entry.hydrated > -1) sout.print(", hydrated=" + entry.hydrated);
				if(entry.duplicates > 0) sout.print(", duplicates=" + entry.duplicates);
				sout.print(", template=" + entry.template);
				sout.print("<br /><pre>" + HTMLFilter.filter(entry.getSQL()) + "</pre></div>");
			}
		}
		catch(Exception ex) {
			org.webdsl.logging.Logger.error("EXCEPTION",ex);
			sout.print("<pre class=\"sqllogexception\">" + HTMLFilter.filter(ex.toString()) + "</pre>");
		}
	}

	protected void checkDuplicate(org.hibernate.Session session, HibernateLogEntry entry, HibernateLogEntityResult res) {
		Object obj = null;
		try{
			obj = session.load(res.entity, UUID.fromString(res.id));
		} catch(Exception e) {
		}
		// If load returned an uninitialized proxy then we set it to null, so that we do not use it (to prevent initialization)
		// However, load should never return an uninitialized proxy, because we are looking at entities that should have been hydrated
		if(obj instanceof HibernateProxy && ((HibernateProxy)obj).getHibernateLazyInitializer().isUninitialized()) obj = null;
		if(obj instanceof WebDSLEntity) {
			res.entity = ((WebDSLEntity)obj).get_WebDslEntityType(); // This returns the correct sub-entity
		}
		else {
			// This only happens if entId is not a UUID, load threw an exception or returned an uninitialized proxy.
			// We record it with the type shown inside the EntityKey, but the real sub-type is unknown
			if(res.entity.indexOf("webdsl.generated.domain.") == 0) res.entity = res.entity.substring("webdsl.generated.domain.".length());
			res.entity = res.entity + " (subtype uknown)";
		}
		if(_fetched.contains(res.entity+"#"+res.id)) {
			_duplicates++;
			if(entry != null) entry.duplicates++;
			if(_duplicateCounter.containsKey(res.entity)) {
				_duplicateCounter.put(res.entity, _duplicateCounter.get(res.entity) + 1);
			}
			else {
				_duplicateCounter.put(res.entity, 1);
			}
		}
		else {
			_fetched.add(res.entity+"#"+res.id);
		}
	}

	public void parseSessionCache(org.hibernate.Session session) {
		if(!_entries.empty()) {
			_error = "Not all statements were closed";
		}
		if(session != null && session instanceof SessionImplementor) {
			for(HibernateLogEntry entry : _list) {
				for(HibernateLogEntityResult res : entry.results) {
					checkDuplicate(session, entry, res);
				}
			}
			for(HibernateLogEntityResult res : _results) {
				checkDuplicate(session, null, res);
			}

			org.hibernate.engine.PersistenceContext context = ((SessionImplementor)session).getPersistenceContext();
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
						if(ent instanceof EntityEntry) {
							EntityEntry entEntry = (EntityEntry)ent;
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
						if(col instanceof CollectionEntry) {
							CollectionEntry colEntry = (CollectionEntry)col;
							org.hibernate.persister.collection.CollectionPersister persister = colEntry.getLoadedPersister();
							if(persister != null) {
								String name = persister.getRole();
								if(name.indexOf("webdsl.generated.domain.") == 0) name = name.substring("webdsl.generated.domain.".length());
								Integer count = _collectionCounter.get(name);
								if(count == null) count = new Integer(0);
								CollectionKey collectionKey = new CollectionKey( persister, colEntry.getLoadedKey(), ((SessionImplementor)session).getEntityMode() );
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

	public Set<String> getEntities() {
		Set<String> rtn = new HashSet<String>();
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

class HibernateLogEntityResult {
	public String entity;
	public String id;

	public HibernateLogEntityResult(String entity, String id) {
		this.entity = entity;
		this.id = id;
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
	public List<HibernateLogEntityResult> results = new ArrayList<HibernateLogEntityResult>();
	public String sql = null;
	public String template = null;
	public List<String> parameterVals = new ArrayList<String>();
	public List<String> parameterTypes = new ArrayList<String>();

	public String getSQL() {
		if(sql == null) return null;

		StringTokenizer tokens = new StringTokenizer(sql, "/*'\"?", true);
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
