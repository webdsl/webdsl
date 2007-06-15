
syntax = org/webdsl/dsl/syntax/WebDSL

hql = org/webdsl/dsl/syntax/HQL

mixhql = org/webdsl/dsl/syntax/MixHQL

metasyntax = org/webdsl/dsl/syntax/StrategoWebDSL

generator = org/webdsl/dsl/generation/dsl-to-seam

STRSOURCES = \
     $(wildcard org/webdsl/dsl/*/*.str) \
	 $(syntax)-pretty.pp.af \
	 $(syntax).tbl \
	 $(hql)-pretty.pp.af

STRINCLUDES = \
	-I . \
	-I $(HOME)/.nix-profile/share \
	-I $(HOME)/.nix-profile/share/java-front \
	-I $(HOME)/.nix-profile/share/sdf/gpp \
	-I $(HOME)/.nix-profile/share/sdf/xml-front \
	-I org/webdsl/dsl/syntax \
    `pkg-config --variable=strcflags java-front` \
    --verbose 1

STRCFLAGS = \
	-la stratego-xtc \
    -la stratego-lib \
    -la stratego-gpp \
    -la stratego-tool-doc \
    -la stratego-sglr \
    -la ${HOME}/.nix-profile/lib/libjava-front.la

all : $(hql).def $(hql).tbl $(hql).rtg $(hql).str \
      $(hql)-pretty.pp.af $(mixhql).sdf \
      $(syntax).def $(syntax).tbl $(syntax).rtg $(syntax).str \
      $(syntax)-pretty.pp.af \
      $(metasyntax).def $(metasyntax).tbl \
      $(generator)

%.str : %.rtg
	rtg2sig -i $< -o $@

%.def : %.sdf $(wildcard org/webdsl/dsl/syntax/*.sdf)
	pack-sdf -i $< -o $@
	
Mix%.sdf : %.def
	gen-sdf-mix -i $< --main `basename $*` --name Mix`basename $*` -o $@

%.pp : %.def
	ppgen -i $< -o $@

%.pp.af : %.pp
	parse-pp-table -i $< -o $@

%.tbl : %.def
	sdf2table -i $< -o $@ -m `basename $*`

%.rtg : %.def
	sdf2rtg -i $< -o $@ -m `basename $*`

%.str-pp : %.str
	parse-stratego $(STRINCLUDES) -i $< | pp-aterm -o $@
	
clean :
	rm -f *.def *.tbl *.rtg \
		org/webdsl/dsl/*/*.c \
		org/webdsl/dsl/*/*.o \
		org/webdsl/dsl/*/*.pp.af

% : %.str $(STRSOURCES)
	echo $(STRCFLAGS)
	strc -i $< -o $@ $(STRCFLAGS) $(STRINCLUDES) -m `basename $@`-main

%.str.pp : %.str
	pp-stratego -i $< -o $@ $(STRINCLUDES)
