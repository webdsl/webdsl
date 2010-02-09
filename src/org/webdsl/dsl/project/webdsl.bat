set BINPREFIX=%~dp0
set PREFIX=%BINPREFIX%..\
set PWD=%CD%
set SIGILSTAR=%*
ant -f "%PREFIX%share\webdsl\webdsl-build.xml" -Dtemplatedir="%PREFIX%share\webdsl" -Dcurrentdir="%PWD%" -Dwebdsl-java-cp="%BINPREFIX%webdsl.jar" -Dwebdslexec="java -ss4m -cp %BINPREFIX%webdsl.jar org.webdsl.webdslc.Main" -Dbuildoptions="%SIGILSTAR%" command
