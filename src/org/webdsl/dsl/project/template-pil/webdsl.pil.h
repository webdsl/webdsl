external class webdsl::db::reflect::DatabaseSessionClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::db::reflect::typeOfDatabaseSession ( ) ;
external class webdsl::reflect::SessionClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::reflect::typeOfSession ( ) ;
external class webdsl::reflect::ResponseClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::reflect::typeOfResponse ( ) ;
external class webdsl::reflect::RequestClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::reflect::typeOfRequest ( ) ;
external class webdsl::util::reflect::StringWriterClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::util::reflect::typeOfStringWriter ( ) ;
external class webdsl::reflect::WebDSLEntityClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::reflect::typeOfWebDSLEntity ( ) ;
external class webdsl::util::reflect::FileClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::util::reflect::typeOfFile ( ) ;
external class webdsl::reflect::TemplateServletClassInfo extends pil::reflect::Class {
    pil::reflect::Class getSuperClass ( ) ;
    pil::String getQualifiedId ( ) ;
    pil::Array < pil::reflect::Field > getFields ( ) ;
    pil::Array < pil::reflect::Method > getMethods ( ) ;
}
external pil::reflect::Class webdsl::reflect::typeOfTemplateServlet ( ) ;
external pil::reflect::Class webdsl::db::reflect::typeOfDatabaseSession ( ) ;
external pil::reflect::Class webdsl::reflect::typeOfSession ( ) ;
external pil::reflect::Class webdsl::reflect::typeOfResponse ( ) ;
external pil::reflect::Class webdsl::reflect::typeOfRequest ( ) ;
external pil::reflect::Class webdsl::util::reflect::typeOfStringWriter ( ) ;
external pil::reflect::Class webdsl::reflect::typeOfWebDSLEntity ( ) ;
external pil::reflect::Class webdsl::util::reflect::typeOfFile ( ) ;
external pil::reflect::Class webdsl::reflect::typeOfTemplateServlet ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfField ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfMethod ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfParameterClass ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfGenericClass ( ) ;
external pil::reflect::Class pil::reflect::reflect::typeOfClass ( ) ;
external pil::reflect::Class pil::reflect::typeOfException ( ) ;
external pil::reflect::Class pil::reflect::typeOfMap ( ) ;
external pil::reflect::Class pil::reflect::typeOfSet ( ) ;
external pil::reflect::Class pil::reflect::typeOfList ( ) ;
external pil::reflect::Class pil::reflect::typeOfExpandingCollection ( ) ;
external pil::reflect::Class pil::reflect::typeOfArray ( ) ;
external pil::reflect::Class pil::reflect::typeOfCollection ( ) ;
external pil::reflect::Class pil::reflect::typeOfMutableString ( ) ;
external pil::reflect::Class pil::reflect::typeOfString ( ) ;
external pil::reflect::Class pil::reflect::typeOfByte ( ) ;
external pil::reflect::Class pil::reflect::typeOfChar ( ) ;
external pil::reflect::Class pil::reflect::typeOfFloat ( ) ;
external pil::reflect::Class pil::reflect::typeOfInt ( ) ;
external pil::reflect::Class pil::reflect::typeOfNumeric ( ) ;
external pil::reflect::Class pil::reflect::typeOfBool ( ) ;
external pil::reflect::Class reflect::typeOfNone ( ) ;
external pil::reflect::Class pil::reflect::typeOfObject ( ) ;
external class webdsl::TemplateServlet extends pil::Object {
}
external class webdsl::util::File extends pil::Object {
}
external class webdsl::WebDSLEntity extends pil::Object {
}
external pil::reflect::Class webdsl::reflect::typeOfWebDSLEntity ( ) ;
external class webdsl::util::StringWriter extends pil::Object {
    new ( ) ;
    void println ( pil::Object o ) ;
    void print ( pil::Object o ) ;
}
external class webdsl::Request extends pil::Object {
    webdsl::Session session ;
    pil::String get ( pil::String key ) ;
}
external class webdsl::Response extends pil::Object {
    webdsl::util::StringWriter writer ;
    void redirect ( pil::String url ) ;
    void setContentType ( pil::String ct ) ;
}
external class webdsl::Session extends pil::Object {
    void set ( pil::String key , pil::Object value ) ;
    pil::Object get ( pil::String key ) ;
}
external pil::String webdsl::encoders::encodeTemplateId ( pil::String template , pil::Array < pil::Object > args , pil::Int templateCounter ) ;
external pil::String webdsl::encoders::encodeHTML ( pil::String text ) ;
external pil::String webdsl::encoders::eliminateTags ( pil::String text ) ;
external class webdsl::db::DatabaseSession extends pil::Object {
    void rollback ( ) ;
    void commit ( ) ;
    void refresh ( pil::Object o ) ;
    pil::List < pil::Object > getAll ( pil::reflect::Class cls ) ;
    void persist ( pil::Object o ) ;
    void delete ( pil::Object o ) ;
}
external webdsl::db::DatabaseSession webdsl::db::getSession ( ) ;