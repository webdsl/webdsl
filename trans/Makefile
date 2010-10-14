ALL_STR = $(wildcard *.str **/*.str ../include/* ../lib/*) 

nwl: $(ALL_STR)
	strc -i compiler.str --main main-nwl-compiler -I .. -Cl stratego-lib -Cl stratego-sglr -o $@

nwljava/nwljava.class: $(ALL_STR)
	strj -i compiler.str -o nwljava -I .. -m main-nwl-compiler -la stratego-sglr -la stratego-gpp -la stratego-aterm
	#javac -cp `which strategoxt.jar` nwljava/nwljava.java
	ecj -1.5 -cp `which strategoxt.jar` nwljava/nwljava.java

nwlj: nwljava/nwljava.class
	touch nwlj
