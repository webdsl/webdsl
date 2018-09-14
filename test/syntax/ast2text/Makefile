# ast2text utility not in standard stratego jar
# .str files copied from: https://github.com/metaborg/strategoxt/blob/master/strategoxt/syntax/gpp/tools/

STRATEGOXT_JAR=../../../src/strategoxt.jar
STRJ=java -Xss8m -Xmx2G -jar $(STRATEGOXT_JAR)
STRJFLAGS=-I . \
  --verbose 3 \
  -la stratego-lib \
  -la stratego-rtg \
  -la stratego-sglr \
  -la stratego-gpp \
  -la stratego-xtc \
  -la stratego-aterm \
  -la stratego-tool-doc \
  -la java-front \
  -clean \

ast2text: clean
	mkdir -p src-gen
	$(STRJ) $(STRJFLAGS) -p syntaxtest -i ast2text.str -o src-gen/syntaxtest/Main.java -m io-ast2text
	mkdir -p bin
	javac src-gen/syntaxtest/Main.java -cp $(STRATEGOXT_JAR):src-gen -d bin

clean:
	rm -rf src-gen/
	rm -rf bin/