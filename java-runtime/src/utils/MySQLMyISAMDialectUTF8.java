package utils;

import org.hibernate.dialect.MySQLMyISAMDialect;

/**
 * Extends MySQLMyISAMDialect with default charset UTF-8
 */
public class MySQLMyISAMDialectUTF8 extends MySQLMyISAMDialect {

    public String getTableTypeString() {
        return " type=MyISAM DEFAULT CHARSET=utf8";
    }
}
