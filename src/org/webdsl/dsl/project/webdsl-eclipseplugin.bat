set BINPREFIX=%~dp0
set PREFIX=%BINPREFIX%..\
set PWD=%CD%
set SIGILSTAR=%*
set STRATEGOJAR=%PREFIX%webdsl-template\template-java-servlet\lib\strategoxt.jar
set WEBDSLJAR=%BINPREFIX%..\include\webdsl.jar
set SHAREWEBDSL=%PREFIX%webdsl-template
ant -f "%SHAREWEBDSL%\webdsl-build.xml" -Dtemplatedir="%SHAREWEBDSL%" -Dcurrentdir="%PWD%" -Dwebdsl-java-cp="%WEBDSLJAR%" -Dstratego-jar-cp="%STRATEGOJAR%" -Dwebdslexec="java -ss4m -cp %WEBDSLJAR% org.webdsl.webdslc.Main" -Dbuildoptions="%SIGILSTAR%" command -lib "%SHAREWEBDSL%/template-java-servlet/lib/webdsl-support.jar" -logger org.webdsl.ant.WebDSLAntLogger