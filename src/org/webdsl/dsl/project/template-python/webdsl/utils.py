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
    h = generateHash(data)
    original_template = template
    while not hasattr(template, 'field_counters'):
        template = template.parent
    if template.field_counters.has_key(h):
        template.field_counters[h] += 1
    else:
        template.field_counters[h] = 1
    return "%s-%s-%d" % (prefix, h, template.field_counters[h])

def generateHash(data):
    h = ''
    if isinstance(data, dict):
        parts = []
        for key, value in data.items():
            parts.append('%s: %s' % (key, generateHash(value)))
        h = hash("\n".join(parts))
    elif isinstance(data, list):
        h = hash("\n".join([generateHash(e) for e in data]))
    elif isinstance(data, webdsl.db.Model):
        try:
            h = hash(data.id)
        except:
            h = hash(data.__class__.__name__)
    else:
        h = hash(data)
    return h

def register(path, cls, param_mappings=[]):
    global mappings
    class _cls(webapp.RequestHandler):
        def get(self, *params):
            out = StringIO()
            o = cls(template_bindings.ParentTemplate(), self, out)
            o.form_counters = {} # Stores hashes => number of forms
            o.field_counters = {} # Stores hashes => number of forms
            i = 0
            d = {}
            while i < len(params):
                (name, id_name, id_type, type) = param_mappings[i]
                param = urllib.unquote(params[i])
                if issubclass(type, webdsl.db.Model):
                    o.scope[name] = type.fetch_by_id(id_type(param))
                    logging.info("Setting this in scope: %s: %s (of type %s)" % (name, param, type))
                else:
                    o.scope[name] = type(param)
                i += 1
            o.title = ""
            o.init()
            o.render()
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
        def post(self, *params):
            self.get(*params)

    mappings.append((path, _cls))

class RequestHandler(object):
    def __init__(self, parent, rh, out, **scope):
        self.template_bindings = parent.template_bindings
        self.scope = parent.scope.copy()
        self.parent = parent
        self.rh = rh
        self.out = out
        for key, value in scope.items():
            self.scope[key] = value

    def init(self):
        self.prepare_templates()
        self.initialize()

#    def data_bind(self):
#        for key, value in self.rh.request.params.items():
#            if '__' in key:
#                (arg, field) = key.split('__')
#                arg = str(arg)
#                setattr(self.scope[arg], field, self.scope[arg].attribute_types[arg](value))

    def redirect_to_self(self):
        self.rh.redirect(self.rh.request.path_info)

    def prepare_templates(self):
        pass

    def initialize(self):
        pass

    def render(self):
        pass

def run():
    application = webapp.WSGIApplication(mappings, debug=True)
    wsgiref.handlers.CGIHandler().run(application)

