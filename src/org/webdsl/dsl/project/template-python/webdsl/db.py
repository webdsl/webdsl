from google.appengine.ext import db
import logging
import simplejson

class Model(db.Model):
    def __init__(self, *params, **kparams):
        self._post_process_props = []
        list_props = filter(lambda attr: isinstance(getattr(self.__class__, attr), db.ListProperty), dir(self.__class__))
        for attr in list_props:
            if kparams.has_key(attr) and kparams[attr] == None:
                kparams[attr] = []
        db.Model.__init__(self, *params, **kparams)
        non_google_properties = filter(lambda attr: not isinstance(getattr(self.__class__, attr), db.Property), kparams.keys())
        for attr in non_google_properties:
            setattr(self, attr, kparams[attr])

    def put(self):
        for attr in self._post_process_props:
            setattr(self, attr+'_count', getattr(self, attr).item_count)
        db.Model.put(self)
        for attr in self._post_process_props:
            getattr(self, attr).inverse_prop_key = self.id
            getattr(self, attr).persist()
        import webdsl.querylist
        webdsl.querylist.query_counter += 1

    def __cmp__(self, other):
        if not other:
            return False
        if self.is_saved() and other.is_saved():
            return cmp(str(self.key()), str(other.key()))
        else:
            return cmp(hash(self), hash(other))

    def as_dict(self, inlined_properties=['id', 'name']):
        d = {}
        for prop in inlined_properties:
            d[prop] = getattr(self, prop)
        return d

    id_property = None

    @property
    def id(self):
        if self.id_property and self.is_saved():
            return getattr(self, self.id_property)
        elif self.is_saved():
            return self.key().id()
        else:
            return None

    @property
    def name(self):
        return self.id

    @classmethod
    def fetch_by_id(cls, id):
        if cls.id_property:
            type = getattr(cls, cls.id_property).data_type
            if isinstance(id, type):
                return cls.all().filter("%s = " % cls.id_property, id).get()
            else:
                return cls.all().filter("%s = " % cls.id_property, type(id)).get()
        else:
            return cls.get_by_id(long(id))

def create_proxy_model(cls):
    class _proxy(cls):
        def __init__(self, id_value, initial_values):
            self._wrapped_object = None
            self._id_value = id_value
            self._initial_values = initial_values

        def __getattribute__(self, attr):
            if attr.startswith('_'):
                return cls.__getattribute__(self, attr)
            if not self._wrapped_object and self._initial_values.has_key(attr):
                return self._initial_values[attr]
            if not self._wrapped_object:
                logging.debug("Lazy loaded whole object: %s id: %s" % (cls, self._id_value))
                self._wrapped_object = cls.fetch_by_id(self._id_value)
            return getattr(self._wrapped_object, attr)

    _proxy.__name__ = "%sProxy" % cls.__name__
    return _proxy

class PartiallyInlinedReferenceProperty(db.Property):
    def __init__(self, type_str, inlined_properties, *params, **kparams):
        self.type_str = type_str
        self.inlined_properties = inlined_properties
        db.Property.__init__(self, *params, **kparams)

    def get_value_for_datastore(self, model_instance):
        if not hasattr(model_instance, self.name):
            return None
        value = getattr(model_instance, self.name)
        if not value:
            return None
        if not value.is_saved():
            value.put()
        return simplejson.dumps(value.as_dict(self.inlined_properties))

    def make_value_from_datastore(self, value):
        if not value:
            return None
        import data
        d = simplejson.loads(value)
        return getattr(data, self.type_str + "Proxy")(d['id'], d)

    def datastore_type(self):
        return db.Text
