//#1 rule type unknown
//#1 rule should contain a Bool expression

application test

entity User{name :: String}

principal is User with credentials name

access control rules

  rule dfgertfcghfersthfgdfghx { true }
  rule logsql { true }
  rule logsql { "not a Bool" }
