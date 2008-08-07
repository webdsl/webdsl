'''
Copyright (c) 2008, appengine-utilities project
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following
conditions are met:
Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following 
disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the appengine-utilities project nor the names of its contributors may be used to endorse or promote 
products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO 
EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
POSSIBILITY OF SUCH DAMAGE.
'''
# main python imports
import pprint, sha, Cookie, os, time, datetime, random, __main__, pickle

# google appengine imports
from google.appengine.ext import db
from google.appengine.api import memcache

# settings, if you have these set elsewhere, such as your django settings file
# you'll need to adjust the values to pull from there.

DEFAULT_COOKIE_PATH = '/'
SESSION_EXPIRE_TIME = 60*120 # Sessions are valid for 60 seconds * 120, or 2 hours
CLEAN_CHECK_PERCENT = 15 # 15 percent of all requests will clean the database 

class _AppEngineUtilities_Sessions(db.Model):
    """
    _AppengineUtilities_Sessions is the datastore class for Sessions. This contains the identifier and validation
    information for the session.
    """
    sid = db.StringProperty()
    ip = db.StringProperty()
    ua = db.StringProperty()
    last_activity = db.DateTimeProperty(auto_now=True)

class _AppEngineUtilities_SessionsData(db.Model):
    """
    _AppEngineUtilities_SessionsData is the datastore for the class for the data attributed to a session.
    """
    sid = db.StringProperty()
    keyname = db.StringProperty()
    content = db.BlobProperty()

class Session(object):
    """
    Session data is kept in the datastore, with a cookie installed on the browser with a
    session id used to reference. The session also stores the user agent and ip of the
    browser to help limit session spoofing. Session data is stored in a referenced entity 
    for each item in the datastore.
    """
    def __init__(self, cookie_path=DEFAULT_COOKIE_PATH, session_expires=SESSION_EXPIRE_TIME):
        ''' When instantiated, always check the cookie and create a new one if necessary.'''
        self.cache = {}
        self.sid = None
        self.session_expires = session_expires
        string_cookie = os.environ.get('HTTP_COOKIE', '')
        self.cookie = Cookie.SimpleCookie()
        self.cookie.load(string_cookie)
        # check for flash data
        if self.cookie.get('appengine-utilities-session-flash'):
            self.flash = pickle.loads(self.cookie['appengine-utilities-session-flash'].value)
            self.cookie['appengine-utilities-session-flash'] = "" 
            self.cookie['appengine-utilities-session-flash']['expires'] = 0 
            print self.cookie
        else:
            if "flash" in self.__dict__:
                del self.__dict__["flash"]
        if self.cookie.get('appengine-utilities-session-sid'):
            self.sid = self.cookie['appengine-utilities-session-sid'].value
            if self.validate_sid() != True:
                self.sid = self.new_sid()
                self.cookie['appengine-utilities-session-sid'] = self.sid
                self.cookie['appengine-utilities-session-sid']['path'] = cookie_path 
                self.cookie['appengine-utilities-session-sid']['expires'] = session_expires 
                print self.cookie
        else:
            self.sid = self.new_sid()
            self.cookie['appengine-utilities-session-sid'] = self.sid
            self.cookie['appengine-utilities-session-sid']['path'] = cookie_path 
            self.cookie['appengine-utilities-session-sid']['expires'] = session_expires 
            print self.cookie

        self.cache['sid'] = pickle.dumps(self.sid)

        ''' Initiate memcache object. '''
        self.memcache = memcache.get("sid-"+self.sid)
        if self.memcache == None:
            memcache.add("sid-"+self.sid, {'sid': self.sid}, session_expires)
            self.memcache = memcache.get("sid-"+self.sid)

        ''' This put is to update the last_activity field in the datastore. So that every time
            the sessions is accessed, the last_activity gets updated.'''
        self.ds.put()

        ''' Random to check to delete old stale sessions in the datastore. (15% of the time)'''
        if random.randint(1, 100) < CLEAN_CHECK_PERCENT:
            self.__clean_old_sessions()

    def new_sid(self):
        """
        new_sid will create a new session id, and store it in a cookie in the browser and then
        instantiate the session in the database.
        """
        if self.sid:
            self.__delete_session(self.sid)
        sid = sha.new(repr(time.time())).hexdigest()
        self.cookie['appengine-utilities-session-sid'] = sid
        self.sid = sid
        self.ds = _AppEngineUtilities_Sessions()
        self.ds.ua = os.environ['HTTP_USER_AGENT']
        self.ds.ip = os.environ['REMOTE_ADDR']
        self.ds.sid = sid
        self.ds.put()
        return sid

    def validate_sid(self):
        """
        validate_sid is used to determine if a session cookie passed from the browser is valid. It
        confirms the session id exists in the data store, and the compares the user agent and ip
        information stored against the browser to validate it.
        """
        if self.sid == None:
            raise ValueError, "sid not defined." 
        self.ds = self.__get_session()
        if self.ds == None:
            return None
        sessionAge = datetime.datetime.now() - self.ds.last_activity
        if self.ds.ua != os.environ['HTTP_USER_AGENT'] or self.ds.ip != os.environ['REMOTE_ADDR'] or sessionAge.seconds > SESSION_EXPIRE_TIME:
            if sessionAge.seconds > SESSION_EXPIRE_TIME:
                self.__delete_session(self.sid)
            return None 
        else:
            return True 
        
    def __get_session(self):
        ''' __get_session uses a session id to return a session from the datastore.'''
        if self.sid == None:
            raise ValueError, "sid not defined." 
        sessions = _AppEngineUtilities_Sessions.gql("WHERE sid = :1 AND ua = :2 LIMIT 1", self.sid, os.environ['HTTP_USER_AGENT'])
        if sessions.count() == 0:
            return None 
        else:
            return sessions[0]

    def get(self, keyname = None):
        """
        get will return all the SessionData object for the session with the session id
        of sid. Optionally, if keyname is provided, it will return just that instance of SessionsData.
        """
        queryStr = "WHERE sid = :1"
        if keyname != None: 
            queryStr += " AND keyname = :2"
            results = _AppEngineUtilities_SessionsData.gql(queryStr, self.ds.sid, keyname)
        else:
            results = _AppEngineUtilities_SessionsData.gql(queryStr, self.ds.sid)
        if results.count() == 0:
            return None
        if keyname != None:
            return results[0]
        return results

    def __validate_key(self, keyname = None):
        """
        Validates the keyname, making sure it is set and not a reserved name.
        """
        if keyname == None:
            raise ValueError, "You must pass a keyname for the session data content."
        if keyname == "sid":
            raise ValueError, "sid is a reserved keyname for session data."
        if keyname == "flash":
            raise ValueError, "flash is a reserved keyname for session data."

    def put(self, keyname = None, content = None):
        """
        put applies a keyname/value pair in SessionsData for the session.
        """
        self.__validate_key(keyname)
        if content == None:
            raise ValueError, "You must pass content for the sessions data."
        sessdata = self.get(keyname = keyname)
        if sessdata == None:
            sessdata = _AppEngineUtilities_SessionsData()
            sessdata.sid = self.ds.sid 
            sessdata.keyname = keyname 
        sessdata.content = pickle.dumps(content)
        self.cache[keyname] = pickle.dumps(content)
        self.memcache[keyname] = content
        memcache.replace("sid-"+self.sid, self.memcache, self.session_expires)
        sessdata.put()
        
    def __delete_session(self, sid = None):
        """
        __delete_session deletes the session and all session date for the sid passed.
        """
        if sid == None:
            if self.sid == None:
                raise ValueError, "sid not defined."
            else:
                sid = self.sid
        queryStr = "WHERE sid = :1"
        sessions = _AppEngineUtilities_Sessions.gql(queryStr, sid)
        sessionsdata = _AppEngineUtilities_SessionsData.gql(queryStr, sid)
        if sessions.count() > 0: 
            if sessionsdata.count() > 0:
                for sd in sessionsdata:
                    db.delete(sd)
            db.delete(sessions)
        ''' Delete from memcache '''
        memcache.delete("sid-"+self.sid)
        # If the event class has been loaded, fire off the sessionDeleted event
        if "AEU_Events" in __main__.__dict__:
            __main__.AEU_Events.fire_event("sessionDeleted")

    def delete(self):
        """
        delete_session deletes the current session and starts a new one. Useful for
        when you need to get rid of all data tied to a current session, such as
        when you are logging out a user of a website.
        """
        self.__delete_session()

    def __clean_old_sessions(self):
        """
         __clean_old_sessions looks for expired sessions and deletes them from the datastore. This
        This should not be called on every request as it could be somewhat intensive, rather
        fire it off a percentage of requests.
        """
        sessionAge = datetime.datetime.now() - datetime.timedelta(seconds=SESSION_EXPIRE_TIME)
        queryStr = "WHERE last_activity < :1"
        sessions = _AppEngineUtilities_Sessions.gql(queryStr, sessionAge)
        if sessions.count() > 0:
            for session in sessions:
                self.__delete_session(session.sid)

    def __getitem__(self, k):
        """ 
        __getitem__ is necessary for this object to emulate a container.
        """
        if k in self.cache:
            return pickle.loads(str(self.cache[k]))
        if k in self.memcache:
            return self.memcache[k]
        data = self.get(k)
        if data:
            self.cache[k] = data.content
            self.memcache[k] = pickle.loads(data.content)
            memcache.replace("sid-"+self.sid, self.memcache, self.session_expires)
            return pickle.loads(data.content)
        else:
            raise KeyError, str(k)

    def __setitem__(self, k, value):
        """ 
        __setitem__ is necessary for this object to emulate a container.
        """
        if type(k) == type(''):
            return self.put(k, value)
        else:
            raise TypeError, "Session data objects are only accessible by string keys, not numerical indexes."

    def __delitem__(self, k):
        """
        Implement the 'del' keyword
        """
        self.__validate_key(k)
        sessdata = self.get(keyname = k)
        if sessdata == None:
            raise KeyError, str(k)
        db.delete(sessdata)
        if k in self.cache:
            del self.cache[k]
        if k in self.memcache:
            del self.memcache[k]
            memcache.replace("sid-"+self.sid, self.memcache, self.session_expires)
 
    def __len__(self):
        """
        Implement the len() function. Note that the GAE documentation says that count()
        is O(n) so don't use this too often, okay?
        """
        return _AppEngineUtilities_SessionsData.all().filter("sid =", self.ds.sid).count()

    def __contains__(self, elt):
        """
        Implements "in" operator
        """
        try:
            r = self.__getitem__(elt)
        except KeyError:
            return False
        return True

    def __iter__(self):
        """
        Returns an iterator for the keys in the session.
        See __str__ in this class for a demonstration!
        """
        for k in _AppEngineUtilities_SessionsData.all().filter("sid =", self.ds.sid):
            yield k.keyname

    def __str__(self):
        """
        String representation. 
        """
        return ", ".join(["(\"%s\" = \"%s\")" % (k, self[k]) for k in self])

    def set_flash_data(self, val):
        """
        Sets a appengine-utilities-session-flash cookie and content.
        """
        self.cookie['appengine-utilities-session-flash'] = pickle.dumps(val)
        print self.cookie
