currently using tomcat 6.0.29


in tomcat.zip changed conf/server.xml, added default keystore for SSL:

    <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
           maxThreads="150" scheme="https" secure="true"
           keystoreFile="../../../../Servers/.keystore" keystorePass="g5o2jD93FQ83Ge52"
           clientAuth="false" sslProtocol="TLS" />