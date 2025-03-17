For command-line tests and 'webdsl run appname' command the Cargo jar is used with the tomcat.zip (currently tomcat 9.0)
The cargo library and Tomcat's server.xml are no longer patched (it previously had webdsl specific ssl-configuration in server.xml)
tomcat.zip is just a repackaged tomcat zip as downloaded from the apache website, but with example apps removed from the webapps dir. 
