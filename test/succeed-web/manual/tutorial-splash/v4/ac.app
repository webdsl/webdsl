module ac

  principal is User with credentials name,password

  access control rules
    rule page *(*){ true }
    rule page admin(e:ALink){ e.event.organizer == principal }
    rule template *(*){ true }