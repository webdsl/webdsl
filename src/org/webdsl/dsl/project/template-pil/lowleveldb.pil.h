external class pil::db::reflect::ResultClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::reflect::typeOfResult ( ) ;
external class pil::db::reflect::ConnectionClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::reflect::typeOfConnection ( ) ;
external class pil::db::reflect::DatabaseClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class pil::db::reflect::typeOfDatabase ( ) ;
external pil::reflect::Class pil::db::reflect::typeOfResult ( ) ;
external pil::reflect::Class pil::db::reflect::typeOfConnection ( ) ;
external pil::reflect::Class pil::db::reflect::typeOfDatabase ( ) ;
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
external class pil::db::Database extends pil::Object {
    new ( pil::db::dialect::Dialect dialect , pil::String hostName , pil::String username , pil::String password , pil::String database ) ;
    pil::db::Connection getConnection ( ) ;
}
external class pil::db::Connection extends pil::Object {
    pil::List < pil::db::Result > query ( pil::String query , pil::Array < pil::Object > args ) ;
    void updateQuery ( pil::String query , pil::Array < pil::Object > args ) ;
    void close ( ) ;
}
external class pil::db::Result extends pil::Object {
    pil::Int getInt ( pil::Int index ) ;
    pil::String getString ( pil::Int index ) ;
    pil::Object getObject ( pil::Int index ) ;
    pil::DateTime getDateTime ( pil::Int index ) ;
}