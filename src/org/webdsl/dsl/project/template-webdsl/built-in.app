module built-in

  type String {
    length():Int
    toLowerCase():String
    toUpperCase():String
    replace(String,String):String
    utils.StringType.parseUUID                   as parseUUID():UUID
    org.webdsl.tools.Utils.containsDigit         as containsDigit():Bool
    org.webdsl.tools.Utils.containsLowerCase     as containsLowerCase():Bool
    org.webdsl.tools.Utils.containsUpperCase     as containsUpperCase():Bool
    org.webdsl.tools.Utils.isCleanUrl            as isCleanUrl():Bool
    org.apache.commons.lang.StringUtils.contains as contains(String):Bool // this 'contains' function handles null, null as either arg will produce false 
    utils.StringType.parseInt                    as parseInt():Int
    utils.StringType.split                       as split():List<String>
    utils.StringType.splitWithSeparator          as split(String):List<String> //TODO Regex as argument
  }