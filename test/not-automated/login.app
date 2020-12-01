application test

page root {
  "note: use http://localhost:8080/login/?nocache for the 'remove all cookie values' action, changing internals does not trigger cache invalidation"
  authentication
  submit action {
    for( sm: SessionManager ){
      sm.cookieValue := null;
    }
  }{ "remove all cookie values" }
  for( sm: SessionManager ){
    div{ "sessionmanager id: ~sm.id" }
    div{ "cookie value: ~sm.cookieValue" }
    div{ "version: ~sm.version" }
    div{ "principal: ~sm.securityContext.principal" }
  }
  h5{ "all messages" }
  for( sm: SessionMessage ){
   div{ ~sm.text }
  }
}

entity User {
  name : String
  pass : Secret
}

var u1 := User{ name := "1" pass := "1" }

principal is User with credentials name, pass

access control rules
  rule page root(){ true }
