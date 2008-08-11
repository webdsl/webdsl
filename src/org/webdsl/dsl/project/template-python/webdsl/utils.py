import wsgiref.handlers
import webdsl.db
import logging
import urllib
import template_bindings
from StringIO import StringIO

from google.appengine.ext import webapp
from google.appengine.ext import db

mappings = []

def new_line():
    return "\n"

def generateFormHash(data, template):
    h = generateHash(data)
    # Find form_counter
    original_template = template
    while not hasattr(template, 'form_counters'):
        template = template.parent
    if template.form_counters.has_key(h):
        template.form_counters[h] += 1
    else:
        template.form_counters[h] = 1
    return "%s-%s-%d" % (original_template.__class__.__name__, h, template.form_counters[h])

def generateUniqueFieldName(data, prefix, template):
    if data.__class__ in [str, int, long]: # If's a primitive
        h = 0
    else:
        h = generateHash(data)
    original_template = template
    while not hasattr(template, 'field_counters'):
        template = template.parent
    if template.field_counters.has_key(h):
        template.field_counters[h] += 1
    else:
        template.field_counters[h] = 1
    logging.info("%s-%s-%d" % (prefix, h, template.field_counters[h]))
    return "%s-%s-%d" % (prefix, h, template.field_counters[h])

def generateHash(data):
    logging.info("Data: %s" % data)
    h = ''
    if isinstance(data, dict):
        parts = []
        for key, value in data.items():
            parts.append('%s: %s' % (key, generateHash(value)))
        return hash("\n".join(parts))
    elif isinstance(data, list):
        return hash("\n".join([generateHash(e) for e in data]))
    elif isinstance(data, webdsl.db.Model):
        h = hash(data.id)
        if not data.id:
            return 0
    else:
        return 0

def register(path, cls, param_mappings=[]):
    global mappings
    class _cls(webapp.RequestHandler):
        def get(self, *params):
            out = StringIO()
            o = cls(template_bindings.ParentTemplate(), self)
            i = 0
            d = {}
            while i < len(params):
                (name, id_type, type) = param_mappings[i]
                param = urllib.unquote(params[i])
                if issubclass(type, webdsl.db.Model):
                    o.scope[name] = type.fetch_by_id(id_type(param))
                else:
                    o.scope[name] = type(param)
                i += 1
            o.title = ""
            o.init() # Initialize page
            o.form_counters = {} # Stores hashes => number of forms
            o.field_counters = {} # Stores hashes => number of forms
            o.action_queue = [] # List of tuples: (callable, params) to be executed at the end of the rendering stage
            o.databind()
            redirect_url = o.invoke_actions() # Invoke actions
            if redirect_url:
                o.rh.redirect(redirect_url)
            o.form_counters = {} # Stores hashes => number of forms
            o.field_counters = {} # Stores hashes => number of forms
            o.action_queue = [] # List of tuples: (callable, params) to be executed at the end of the rendering stage
            o.render(out)
            self.response.out.write('''
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>    
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>%s</title>
    <link href="/stylesheets/webdsl.css" rel="stylesheet" type="text/css" />
</head>
<body>''' % o.title)
            self.response.out.write(out.getvalue())
            self.response.out.write('''</body></html>''')
            o.store_session()
        def post(self, *params):
            self.get(*params)

    mappings.append((path, _cls))

class RequestHandler(object):
    def __init__(self, parent, rh, **scope):
        self.template_bindings = parent.template_bindings
        self.scope = parent.scope.copy()
        self.parent = parent
        self.rh = rh
        self.action_queue = None
        self.templates = []
        self.redirect_url = None
        for key, value in scope.items():
            self.scope[key] = value

    def init(self):
        self.prepare_templates()
        self.load_session()
        self.init_templates()
        self.initialize()

    def queue_action(self, callable, params):
        s = self
        while s.action_queue == None:
            s = s.parent
        s.action_queue.append((callable, params))

    def invoke_actions(self):
        redirect_url = None
        for (callable, params) in self.action_queue:
            ru = callable(*params)
            if ru:
                redirect_url = ru
        return redirect_url

    def redirect_to_self(self):
        self.rh.redirect(self.rh.request.path_info)

    def prepare_templates(self):
        pass

    def load_session(self):
        pass

    def initialize(self):
        pass

    def render(self, out):
        pass

    def databind(self):
        pass

def run():
    application = webapp.WSGIApplication(mappings, debug=True)
    wsgiref.handlers.CGIHandler().run(application)

