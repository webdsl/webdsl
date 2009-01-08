#
# Copyright (c) 2008 Andreas Blixt <andreas@blixt.org>
# Project homepage: <http://code.google.com/p/blixt/>
#
# License: MIT license <http://www.opensource.org/licenses/mit-license.php>
#

"""Data-related Google App Engine extensions.
"""

from google.appengine.ext import db
import webdsl.db

import sys

class Error(Exception):
    """Base of all exceptions in the blixt.data module."""
    pass

class PolyModel(webdsl.db.Model):
    """An extension to Google App Engine models that improves the support for
    inheritance.

    Any models extending a model that extends PolyModel will be stored in the
    datastore as the same kind as the model that extends PolyModel, but with
    their additional properties. When they are retrieved from the datastore,
    they will be loaded as the appropiate model class.

    The difference from the Model class is that queries will include models that
    inherit from the model being queried.
    """
    inheritance_line = db.StringListProperty()

    def __init__(self, parent = None, key_name = None, _app = None, **kwds):
        """Creates a new instance of this polymorphic model.

        Args:
          parent: Parent instance for this instance or None, indicating a top-
            level instance.
          key_name: Name for new model instance.
          _app: Intentionally undocumented.
          args: Keyword arguments mapping to properties of model.
        """
        if self.__class__ == PolyModel or not isinstance(self, PolyModel):
            raise Error('Instances of PolyModel must be created through a '
                        'subclass of PolyModel.')

        line = []
        for c in self.__class__.__mro__:
            if c == PolyModel:
                self.__class__._kind = p
                break
            line.append('%s.%s' % (c.__module__, c.__name__))
            p = c

        kwds['inheritance_line'] = line

        super(PolyModel, self).__init__(parent = parent, key_name = key_name,
                                        _app = _app, **kwds)

    @classmethod
    def _kind_type(cls):
        """Gets the class highest in the model inheritance hierarchy (the class
        that will be used as the datastore kind.)
        """
        p = cls

        for c in cls.__mro__:
            # The meta-class 'PropertiedClass' calls kind() which leads here.
            # The variable 'PolyModel' is not assigned until after the meta-
            # class has finished setting up the class. Therefore, a string
            # comparison is used instead of a value comparison.
            if c.__name__ == 'PolyModel': break
            p = c

        return p

    @classmethod
    def all(cls):
        """Returns a query over all instances of this model, as well as the
        instances of any descendant models, from the datastore.

        Returns:
          Query that will retrieve all instances from entity collection.
        """
        qry = super(PolyModel, cls).all()

        if cls != cls._kind_type():
            full_name = '%s.%s' % (cls.__module__, cls.__name__)
            qry.filter('inheritance_line =', full_name)

        return qry

    @classmethod
    def from_entity(cls, entity):
        """Converts the entity representation of this model to an instance.

        Converts datastore.Entity instance to an instance of the appropiate
        class, which can be cls or any descendant thereof.

        Args:
          entity: Entity loaded directly from datastore.

        Raises:
          KindError when cls is incorrect model for entity.
        """
        if entity.has_key('inheritance_line'):
            mod_name, cls_name = entity['inheritance_line'][0].rsplit('.', 1)
            __import__(mod_name)
            cls = getattr(sys.modules[mod_name], cls_name)
        return super(PolyModel, cls).from_entity(entity)

    @classmethod
    def kind(cls):
        """Returns the datastore kind we use for this model.

        This is the name of the class that is highest up in the inheritance
        hierarchy of this model.
        """
        return cls._kind_type().__name__
