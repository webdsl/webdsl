ALL_STR = $(wildcard *.str **/*.str ../include/* ../lib/* ../separation/*)

nwl: $(ALL_STR)
	strc -i compiler.str --main main-nwl-compiler -I .. -Cl stratego-lib -Cl stratego-sglr -Cl stratego-aterm -o $@

nwljava/nwljava.class: $(ALL_STR)
	strj -i compiler.str -o nwljava -I ../include -I .. -m main-nwl-compiler -la stratego-sglr -la stratego-gpp -la stratego-aterm
	ecj -1.5 -cp `which strategoxt.jar` nwljava/nwljava.java

#out/separation/separation.java: $(SEP_STR)
#	mkdir -p out
#	strj -i ../separation/lib.str -o out/libsepcomp -p sepcomp -I .. --library -la stratego-sglr -la stratego-gpp -la stratego-aterm

nwlj: nwljava/nwljava.class
	touch nwlj

clean: 
	rm -rf nwljava
	rm -f *.rtree *.dep

