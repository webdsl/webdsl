package utils;

import org.hibernate.dialect.MySQL5InnoDBDialect;

/**
 * Extends MySQL5InnoDBDialect with default charset UTF-8
 */
public class MySQL5InnoDBDialectUTF8 extends MySQL5InnoDBDialect {

    public String getTableTypeString() {
        return " type=InnoDB DEFAULT CHARSET=utf8";
    }
}
