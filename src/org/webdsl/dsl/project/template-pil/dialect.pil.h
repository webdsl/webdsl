external class pil::db::type::reflect::StringDBTypeClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::type::reflect::typeOfStringDBType ( ) ;
external class pil::db::type::reflect::IntDBTypeClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::type::reflect::typeOfIntDBType ( ) ;
external class pil::db::type::reflect::DBTypeClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::type::reflect::typeOfDBType ( ) ;
external class pil::db::dialect::reflect::MySQLDialectClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::dialect::reflect::typeOfMySQLDialect ( ) ;
external class pil::db::dialect::reflect::DialectClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::dialect::reflect::typeOfDialect ( ) ;
external pil::reflect::Class pil::db::type::reflect::typeOfStringDBType ( ) ;
external pil::reflect::Class pil::db::type::reflect::typeOfIntDBType ( ) ;
external pil::reflect::Class pil::db::type::reflect::typeOfDBType ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfField ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfMethod ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfParameterClass ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfGenericClass ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfClass ( ) ;
external pil::reflect::Class pil::reflect::typeOfFunction4 ( ) ;
external pil::reflect::Class pil::reflect::typeOfFunction3 ( ) ;
external pil::reflect::Class pil::reflect::typeOfFunction2 ( ) ;
external pil::reflect::Class pil::reflect::typeOfFunction1 ( ) ;
external pil::reflect::Class pil::reflect::typeOfFunction0 ( ) ;
external pil::reflect::Class pil::reflect::typeOfNullPointerException ( ) ;
external pil::reflect::Class pil::reflect::typeOfException ( ) ;
external pil::reflect::Class pil::reflect::typeOfMap ( ) ;
external pil::reflect::Class pil::reflect::typeOfSet ( ) ;
external pil::reflect::Class pil::reflect::typeOfList ( ) ;
external pil::reflect::Class pil::reflect::typeOfExpandingCollection ( ) ;
external pil::reflect::Class pil::reflect::typeOfArray ( ) ;
external pil::reflect::Class pil::reflect::typeOfCollection ( ) ;
external pil::reflect::Class pil::reflect::typeOfMutableString ( ) ;
external pil::reflect::Class pil::reflect::typeOfString ( ) ;
external pil::reflect::Class pil::reflect::typeOfDateTime ( ) ;
external pil::reflect::Class pil::reflect::typeOfByte ( ) ;
external pil::reflect::Class pil::reflect::typeOfChar ( ) ;
external pil::reflect::Class pil::reflect::typeOfFloat ( ) ;
external pil::reflect::Class pil::reflect::typeOfInt ( ) ;
external pil::reflect::Class pil::reflect::typeOfNumeric ( ) ;
external pil::reflect::Class pil::reflect::typeOfBool ( ) ;
external pil::reflect::Class reflect::typeOfNone ( ) ;
external pil::reflect::Class pil::reflect::typeOfObject ( ) ;
external class pil::db::type::DBType extends pil::Object {
}
external class pil::db::type::IntDBType extends pil::db::type::DBType {
    as<pil::String>;
}
external pil::db::type::IntDBType pil::db::type::intType ;
external class pil::db::type::StringDBType extends pil::db::type::DBType {
    as<pil::String>;
}
external pil::db::type::StringDBType pil::db::type::stringType ;
external class pil::db::dialect::Dialect extends pil::Object {
    pil::Map < pil::db::type::DBType , pil::String > types ;
    pil::String getType ( pil::db::type::DBType type , pil::Int size ) ;
    pil::String tableNameQuery ( ) ;
    pil::reflect::Class getClassInfo ( ) ;
    pil::Map < pil::db::type::DBType , pil::String > getTypes ( ) ;
    void setTypes ( pil::Map < pil::db::type::DBType , pil::String > value ) ;
}
external class pil::db::dialect::MySQLDialect extends pil::db::dialect::Dialect {
    new ( ) ;
    pil::String getType ( pil::db::type::DBType type , pil::Int size ) ;
    pil::String tableNameQuery ( ) ;
    pil::reflect::Class getClassInfo ( ) ;
}