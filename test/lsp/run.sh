mkdir -p .servletapp/src-webdsl-template/
cp ../../src/org/webdsl/dsl/project/template-webdsl/built-in.app .servletapp/src-webdsl-template/
javac -cp ../../src/strategoxt.jar:../../src/webdsl.jar src/TestLSP.java -d bin/
java -cp bin:../../src/strategoxt.jar:../../src/webdsl.jar TestLSP
if [ $? -eq 0 ]
then
  echo "All tests successful."
  exit 0
else
  echo "Some tests failed."
  exit 1
fi