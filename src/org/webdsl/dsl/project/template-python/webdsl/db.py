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
        non_google_properties = filter(lambda attr: hasattr(self.__class__, attr) and not isinstance(getattr(self.__class__, attr), db.Property), kparams.keys())
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
            return cmp(self.__class__, other) # Nonesense
        if self.is_saved() and other.is_saved():
            return cmp(str(self.key()), str(other.key()))
        else:
            return cmp(hash(self), hash(other))

    def as_dict(self, inlined_properties=['id', 'name']):
        d = {}
        for prop in inlined_properties:
            try:
                d[prop] = getattr(self, prop)
            except:
                pass
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
            if (attr.startswith('_') and not attr.startswith('__')) or attr == '__cmp__':
                return cls.__getattribute__(self, attr)
            if not self._wrapped_object and self._initial_values.has_key(attr):
                return self._initial_values[attr]
            if not self._wrapped_object:
                logging.debug("Lazy loaded whole object: %s id: %s" % (cls, self._id_value))
                self._wrapped_object = cls.fetch_by_id(self._id_value)
            return getattr(self._wrapped_object, attr)

        def __setattr__(self, attr, value):
            if (attr.startswith('_') and not attr.startswith('__')) or attr == '__cmp__':
                return cls.__setattr__(self, attr, value)
            if self._wrapped_object == None:
                logging.debug("Lazy loaded whole object: %s id: %s" % (cls, self._id_value))
                self._wrapped_object = cls.fetch_by_id(self._id_value)
            setattr(self._wrapped_object, attr, value)

        def __cmp__(self, other):
            if self._wrapped_object == None:
                self._wrapped_object = cls.fetch_by_id(self._id_value)
            return cmp(self._wrapped_object, other)

    _proxy.__name__ = "%sProxy" % cls.__name__
    return _proxy

class PartiallyInlinedReferenceProperty(db.Property):
    def __init__(self, type_str, inlined_properties, *params, **kparams):
        self.type_str = type_str
        self.inlined_properties = inlined_properties
        db.Property.__init__(self, *params, **kparams)

    def get_value_for_datastore(self, model_instance):
        if not hasattr(model_instance, self._attr_name()):
            return None
        value = getattr(model_instance, self._attr_name())
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

class PartiallyOneInlinedReferenceProperty(db.Property):
    def __init__(self, type_str, inlined_properties, *params, **kparams):
        self.type_str = type_str
        self.inlined_properties = inlined_properties
        db.Property.__init__(self, *params, **kparams)

    def get_value_for_datastore(self, model_instance):
        if not hasattr(model_instance, self._attr_name()):
            return None
        value = getattr(model_instance, self._attr_name())
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

    def __set__(self, model_instance, value):
        setattr(model_instance, self._attr_name(), value)
        setattr(model_instance, self.name.replace('_inline', '_id'), value)

class SimpleReferenceProperty(db.Property):
  def __init__(self,
               reference_class=None,
               verbose_name=None,
               **attrs):
    super(SimpleReferenceProperty, self).__init__(verbose_name, **attrs)

    if reference_class is None:
      reference_class = Model
    if not ((isinstance(reference_class, type) and
             issubclass(reference_class, Model)) or
            reference_class is db._SELF_REFERENCE):
      raise KindError('reference_class must be Model or _SELF_REFERENCE')
    self.reference_class = self.data_type = reference_class

  def __property_config__(self, model_class, property_name):
    super(SimpleReferenceProperty, self).__property_config__(model_class,
                                                       property_name)

    if self.reference_class is db._SELF_REFERENCE:
      self.reference_class = self.data_type = model_class

  def __get__(self, model_instance, model_class):
    if model_instance is None:
      return self
    if hasattr(model_instance, self.__id_attr_name()):
      reference_id = getattr(model_instance, self.__id_attr_name())
    else:
      reference_id = None
    if reference_id is not None:
      resolved = getattr(model_instance, self.__resolved_attr_name())
      if resolved is not None:
        return resolved
      else:
        instance = get(reference_id)
        if instance is None:
          raise Error('SimpleReferenceProperty failed to be resolved')
        setattr(model_instance, self.__resolved_attr_name(), instance)
        return instance
    else:
      return None

  def __set__(self, model_instance, value):
    """Set reference."""
    value = self.validate(value)
    if value is not None:
      if isinstance(value, db.datastore.Key):
        setattr(model_instance, self.__id_attr_name(), value)
        setattr(model_instance, self.__resolved_attr_name(), None)
      else:
        setattr(model_instance, self.__id_attr_name(), value.key())
        setattr(model_instance, self.__resolved_attr_name(), value)
    else:
      setattr(model_instance, self.__id_attr_name(), None)
      setattr(model_instance, self.__resolved_attr_name(), None)

  def get_value_for_datastore(self, model_instance):
    return getattr(model_instance, self.__id_attr_name())

  def validate(self, value):
    if isinstance(value, db.datastore.Key):
      return value

    if value is not None and not value.is_saved():
      raise BadValueError(
          '%s instance must be saved before it can be stored as a '
          'reference' % self.reference_class.kind())

    value = super(SimpleReferenceProperty, self).validate(value)

    if value is not None and not isinstance(value, self.reference_class):
      raise KindError('Property %s must be an instance of %s' %
                            (self.name, self.reference_class.kind()))

    return value

  def __id_attr_name(self):
    return self._attr_name()

  def __resolved_attr_name(self):
    return '_RESOLVED' + self._attr_name()

