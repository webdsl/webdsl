
syntax = org/webdsl/dsl/syntax/WebDSL

metasyntax = org/webdsl/dsl/syntax/StrategoWebDSL

generator = org/webdsl/dsl/generation/dsl-to-seam

STRSOURCES = \
     $(wildcard org/webdsl/dsl/*/*.str) \
	 $(syntax)-pretty.pp.af \
	 $(syntax).tbl

STRINCLUDES = \
	-I . \
	-I $(HOME)/.nix-profile/share \
	-I $(HOME)/.nix-profile/share/java-front \
	-I $(HOME)/.nix-profile/share/sdf/gpp \
	-I $(HOME)/.nix-profile/share/sdf/xml-front \
	-I org/webdsl/dsl/syntax \
    `pkg-config --variable=strcflags java-front` \
    --verbose 3

STRCFLAGS = \
	-la stratego-xtc \
    -la stratego-lib \
    -la stratego-gpp \
    -la stratego-tool-doc \
    -la stratego-sglr \
    -la ${HOME}/.nix-profile/lib/libjava-front.la

all : $(syntax).def $(syntax).tbl $(syntax).rtg $(syntax).str \
      $(syntax)-pretty.pp.af \
      $(metasyntax).def $(metasyntax).tbl \
      $(generator)

%.str : %.rtg
	rtg2sig -i $< -o $@

%.def : %.sdf $(wildcard org/webdsl/dsl/syntax/*.sdf)
	pack-sdf -i $< -o $@

%.pp.af : %.pp
	parse-pp-table -i $< -o $@

%.tbl : %.def
	sdf2table -i $< -o $@ -m `basename $*`

%.rtg : %.def
	sdf2rtg -i $< -o $@ -m `basename $*`

%.str-pp : %.str
	parse-stratego $(STRINCLUDES) -i $< | pp-aterm -o $@
	
clean :
	rm -f *.def *.tbl *.rtg org/webdsl/dsl/*/*.c org/webdsl/dsl/*/*.o

% : %.str $(STRSOURCES)
	echo $(STRCFLAGS)
	strc -i $< -o $@ $(STRCFLAGS) $(STRINCLUDES) -m `basename $@`-main

%.str.pp : %.str
	pp-stratego -i $< -o $@ $(STRINCLUDES)
