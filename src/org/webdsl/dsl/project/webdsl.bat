set BINPREFIX=%~dp0
set PREFIX=%BINPREFIX%..\
set PWD=%CD%
set SIGILSTAR=%*
set WEBDSLJAR=%BINPREFIX%webdsl.jar
set SHAREWEBDSL=%PREFIX%share\webdsl
ant -f "%SHAREWEBDSL%\webdsl-build.xml" -Dtemplatedir="%SHAREWEBDSL%" -Dcurrentdir="%PWD%" -Dwebdsl-java-cp="%WEBDSLJAR%" -Dwebdslexec="java -ss4m -cp %WEBDSLJAR% org.webdsl.webdslc.Main" -Dbuildoptions="%SIGILSTAR%" command -lib "%SHAREWEBDSL%/template-java-servlet/lib/webdsl-support.jar" -logger org.webdsl.ant.WebDSLAntLogger
