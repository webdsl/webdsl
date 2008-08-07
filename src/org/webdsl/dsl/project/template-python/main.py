from google.appengine.ext import db
import webdsl.db
import webdsl.utils
import webdsl.querylist
from datetime import datetime
import data
import template
import logging

webdsl.querylist.query_counter = 0
#print 'Content-type: text/plain'
#print
#print 'Deleting old junk...'
#t = datetime.now()
#print 'Hoi!'
#for u in data.User.all():
#    u.delete()
#for e in data.Entry.all():
#    e.delete()
#u = data.User(username="Sjaak")
#e = data.Entry()
#e.message = "Hoi!"
#u.entries.append(e)
#u.put()
# print datetime.now() - t
# print 'Ok, ready? Go!'
# 
# print 'Making a new object, adding a bunch of messages...'
# t = datetime.now()
# u = data.User()
# u.username = 'Eelco'
# u.put()
# u2 = data.User()
# u2.username = 'Zef'
# u2.put()
# 
# m = data.Message(message='Goede morgen (zegt Zef)!', recipients=[u,u2])
# print m.recipients
# u.messages.append(m)
# u.messages.append(data.Message(message='Smoi!', recipients=[u]))
# print 'Before removing:'
# print u.messages
# u.messages.remove(m)
# print 'After removing:'
# print u.messages
# print 'Re-adding...'
# u.messages.append(m)
# print u.messages
# print datetime.now() - t
# u.put()
# print [m.sender.username for m in u.messages]
# print 'All of Eelco\'s received messages:'
# print u.receivedmessages

main = webdsl.utils.run

if __name__ == '__main__':
    main()

#print 'Total of %d queries.' % webdsl.querylist.query_counter
