package utils;

import org.hibernate.dialect.MySQL5InnoDBDialect;

import utils.BuildProperties.DefaultCharSet;

/**
 * Extends MySQL5InnoDBDialect with default charset UTF-8
 */
public class MySQL5InnoDBDialectUTF8 extends MySQL5InnoDBDialect { 

    public String getTableTypeString() {
      if(BuildProperties.getDefaultCharSet() == DefaultCharSet.UTF8MB4) { 
        return " engine=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
      } else {
        return " engine=InnoDB DEFAULT CHARSET=utf8";
      }
    }

}
