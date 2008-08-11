from google.appengine.ext import db
import logging

op_to_filter = { 'eq': '=',  'neq': '!=', 'lt': '<', 'leq': '<=', 'gt': '>', 'geq': '>=', 'in': '=' }

query_counter = 0

class QuerySet(object):
    def __init__(self, lst):
        self.lst = list(lst)
        self.filters = []
        self.order = None
        self.limit_ = 1000
        self.offset = 0

    def filter_eq(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'eq', val))
        return c

    def filter_neq(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'neq', val))
        return c

    def filter_lt(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'lt', val))
        return c

    def filter_leq(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'leq', val))
        return c

    def filter_gt(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'gt', val))
        return c

    def filter_geq(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'geq', val))
        return c

    def filter_in(self, prop, val):
        c = self.copy()
        c.filters.append((prop, 'in', val))
        return c

    def order_by(self, prop):
        c = self.copy()
        c.order = prop
        return c

    def limit(self, limit, offset=0):
        c = self.copy()
        c.limit_ = limit
        c.offset = offset
        return c

    def list(self):
        lst = self.lst[:]
        for prop, op, val in self.filters:
            if prop:
                if op == 'eq':
                    # @TODO: Take lists into consideration
                    lst = filter(lambda o: getattr(o, prop) == val, lst)
                elif op == 'neq':
                    lst = filter(lambda o: getattr(o, prop) != val, lst)
                elif op == 'lt':
                    lst = filter(lambda o: getattr(o, prop) < val, lst)
                elif op == 'leq':
                    lst = filter(lambda o: getattr(o, prop) <= val, lst)
                elif op == 'gt':
                    lst = filter(lambda o: getattr(o, prop) > val, lst)
                elif op == 'geq':
                    lst = filter(lambda o: getattr(o, prop) >= val, lst)
                elif op == 'in':
                    lst = filter(lambda o: val in getattr(o, prop), lst)
            else:
                if op == 'eq':
                    lst = filter(lambda v: v == val, lst)
                elif op == 'neq':
                    lst = filter(lambda v: v != val, lst)
                elif op == 'lt':
                    lst = filter(lambda v: v < val, lst)
                elif op == 'leq':
                    lst = filter(lambda v: v <= val, lst)
                elif op == 'gt':
                    lst = filter(lambda v: v > val, lst)
                elif op == 'geq':
                    lst = filter(lambda v: v >= val, lst)
                elif op == 'in':
                    lst = filter(lambda v: val in v, lst)
        if self.order:
            descending = False
            prop = self.order
            if prop.startswith('-'):
                descending = True
                prop = prop[1:]
            if prop:
                if not descending:
                    lst.sort(lambda x, y: cmp(getattr(x, prop), getattr(y, prop)))
                else:
                    lst.sort(lambda x, y: cmp(getattr(y, prop), getattr(x, prop)))
            else:
                if not descending:
                    lst.sort(lambda x, y: cmp(x, y))
                else:
                    lst.sort(lambda x, y: cmp(y, x))
        return lst[self.offset:self.offset+self.limit_]

    def append(self, item):
        self.lst.append(item)

    def remove(self, item):
        if item in self.lst:
            self.lst.remove(item)

    def copy(self):
        c = QuerySet(self.lst)
        c.filters = self.filters[:]
        c.order = self.order
        c.limit_ = self.limit_
        c.offset = self.offset
        return c

    def __repr__(self):
        return repr(self.list())
    
    def __iter__(self):
        return iter(self.list())

    def __len__(self):
        if not self.filters:
            return len(self.lst)
        else:
            return len(self.list())

class OneToManyDbQuerySet(QuerySet):
    """Database version of QuerySet"""
    def __init__(self, obj, type, inverse_prop, inverse_prop_key, item_count, declared_inverse_prop=None):
        QuerySet.__init__(self, [])
        self.obj = obj
        if isinstance(type, basestring):
            import data
            type = getattr(data, type)
        self.type = type
        self.item_count = item_count
        self.inverse_prop = inverse_prop
        self.inverse_prop_key = inverse_prop_key
        self.declared_inverse_prop = declared_inverse_prop
        self.append_list = []
        self.remove_list = []
        self.query_list = QuerySet([])

    def append(self, item):
        if not item in self.append_list:
            self.item_count += 1
            self.append_list.append(item)
            if self.declared_inverse_prop:
                setattr(item, self.declared_inverse_prop, self.obj)

    def remove(self, item):
        self.item_count -= 1
        if item in self.append_list:
            self.append_list.remove(item)
        else:
            self.remove_list.append(item)
        if self.declared_inverse_prop:
            setattr(item, self.declared_inverse_prop, None)

    def list(self):
        query_list = QuerySet(self.query_list.lst[:])
        if self.inverse_prop_key:
            self.query = self.type.all().filter("%s =" % self.inverse_prop, self.inverse_prop_key)
            logging.info("All: %s" %  list(self.query))
            for prop, op, val in self.filters:
                self.query.filter('%s %s' % (prop, op_to_filter[op]), val)
            if self.order:
                self.query.order(self.order)
            query_list = QuerySet(list(self.query.fetch(self.limit_ + len(self.remove_list), self.offset)))
            global query_counter
            query_counter += 1

        if not self.inverse_prop_key or self.append_list or self.remove_list:
            for item in self.append_list:
                query_list.append(item)
            for item in self.remove_list:
                query_list.remove(item)
            for prop, op, val in self.filters:
                query_list = getattr(query_list, 'filter_%s' % op)(prop, val)
            if self.order:
                query_list = query_list.order_by(self.order)
        return query_list.limit(self.limit_, self.offset).list()

    def persist(self):
        for item in self.append_list:
            setattr(item, self.inverse_prop, self.inverse_prop_key)
            setattr(item, self.inverse_prop + "_inline", self.obj)
            item.put()
        for item in self.remove_list:
            setattr(item, self.inverse_prop, None)
            setattr(item, self.inverse_prop + "_inline", None)
            item.put()
        self.append_list = []
        self.remove_list = []

    def copy(self):
        c = self.__class__(self.obj, self.type, self.inverse_prop, self.inverse_prop_key, self.item_count)
        c.filters = self.filters[:]
        c.order = self.order
        c.limit_ = self.limit_
        c.offset = self.offset
        c.append_list = self.append_list
        c.remove_list = self.remove_list
        return c

    def __len__(self):
        if not self.filters:
            return self.item_count
        else:
            return len(self.list())


class ManyToManyDbQuerySet(OneToManyDbQuerySet):
    """Database version of QuerySet"""

    def append(self, item):
        if not item in self.append_list:
            self.item_count += 1
            self.append_list.append(item)
            logging.info(item)
            if self.declared_inverse_prop:
                getattr(item, self.declared_inverse_prop).append(self.obj)

    def remove(self, item):
        self.item_count -= 1
        if item in self.append_list:
            self.append_list.remove(item)
        else:
            self.remove_list.append(item)
        if self.declared_inverse_prop:
            getattr(item, self.declared_inverse_prop).remove(self.obj)

    def persist(self):
        '''We now have a key, put it in all the appended items!'''
        for item in self.append_list:
            if not self.inverse_prop_key in getattr(item, self.inverse_prop):
                getattr(item, self.inverse_prop).append(self.inverse_prop_key)
                item.put() 
        for item in self.remove_list:
            getattr(item, self.inverse_prop).remove(self.inverse_prop_key)
            item.put()
        self.append_list = []
        self.remove_list = []

class AllDbQuerySet(QuerySet):
    """Database version of QuerySet"""
    def __init__(self, type):
        QuerySet.__init__(self, [])
        self.type = type
        self.append_list = []
        self.remove_list = []
        self.query = type.all()

    def append(self, item):
        self.append_list.append(item)

    def remove(self, item):
        self.item_count -= 1
        if item in self.append_list:
            self.append_list.remove(item)
        else:
            self.remove_list.append(item)

    def list(self):
        for prop, op, val in self.filters:
            self.query.filter('%s %s' % (prop, op_to_filter[op]), val)
        if self.order:
            self.query.order(self.order)
        self.query_list = QuerySet(list(self.query.fetch(self.limit_ + len(self.remove_list), self.offset)))
        global query_counter
        query_counter += 1

        if self.append_list or self.remove_list:
            for item in self.append_list:
                self.query_list.append(item)
            for prop, op, val in self.filters:
                self.query_list = getattr(self.query_list, 'filter_%s' % op)(prop, val)
            if self.order:
                self.query_list = self.query_list.order_by(self.order)

        return self.query_list.limit(self.limit_).list()

    def copy(self):
        c = AllDbQuerySet(self.type)
        c.filters = self.filters[:]
        c.order = self.order
        c.limit_ = self.limit_
        c.offset = self.offset
        c.append_list = self.append_list
        c.remove_list = self.remove_list
        return c

class QuerySetProperty(db.Property):

    def __set__(self, model_instance, value):
        if value:
            setattr(model_instance, self._attr_name(), QuerySet(value))

    def __get__(self, model_instance, model_class):
        if not model_instance:
            return self
        if not hasattr(model_instance, self._attr_name()):
            setattr(model_instance, self._attr_name(), QuerySet([]))
        return getattr(model_instance, self._attr_name())

    def get_value_for_datastore(self, model_instance):
        return getattr(model_instance, self.name).list()

    def make_value_from_datastore(self, value):
        return QuerySet(value)

    def datastore_type(self):
        return list
