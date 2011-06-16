ALL_STR = $(wildcard *.str **/*.str ../include/* ../lib/* ../separation/* ../separation/**/* ../separation/**/**/*)

nwlj: nwljava/nwljava.class
	touch nwlj

nwl: $(ALL_STR)
	strc -i compiler.str --main main-nwl-compiler -I .. -Cl stratego-lib -Cl stratego-sglr -Cl stratego-aterm -o $@

nwljava/nwljava.class: $(ALL_STR)
	cp ../trans/libsepcomp.str.fix ../separation/externals.str
	strj -i compiler.str -o nwljava -I ../include -I .. -m main-nwl-compiler -la stratego-sglr -la stratego-gpp -la stratego-aterm
	svn revert ../separation/externals.str &> /dev/null
	ecj -1.5 -cp `which strategoxt.jar` nwljava/nwljava.java

clean: 
	rm -rf nwljava
	rm -f *.rtree *.dep

