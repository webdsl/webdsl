
syntax = org/webdsl/dsl/syntax/WebDSL

generator = org/webdsl/dsl/generation/dsl-to-seam

preprocessor = org/webdsl/dsl/generation/dsl-desugar

STRSOURCES = $(wildcard org/webdsl/dsl/*/*.str)

STRINCLUDES = \
	-I . \
	-I $(HOME)/.nix-profile/share \
	-I $(HOME)/.nix-profile/share/java-front \
	-I $(HOME)/.nix-profile/share/sdf/gpp \
	-I $(HOME)/.nix-profile/share/sdf/xml-front \
    `pkg-config --variable=strcflags java-front` \
    --verbose 3

STRCFLAGS = \
	-la stratego-xtc \
    -la stratego-lib \
    -la stratego-gpp \
    -la ${HOME}/.nix-profile/lib/libjava-front.la

all : $(syntax).def $(syntax).tbl $(syntax).rtg $(syntax).str $(generator) $(preprocessor)

%.str : %.rtg
	rtg2sig -i $< -o $@

%.def : %.sdf
	pack-sdf -i $< -o $@

%.tbl : %.def
	sdf2table -i $< -o $@ -m $*

%.rtg : %.def
	sdf2rtg -i $< -o $@ -m $*

clean :
	rm -f *.def *.tbl *.rtg *.str

$(generator) : $(generator).str

$(preprocessor) : $(preprocessor).str

% : %.str $(STRSOURCES)
	echo $(STRCFLAGS)
	strc -i $< -o $@ $(STRCFLAGS) $(STRINCLUDES) -m `basename $@`-main

%.str.pp : %.str
	pp-stratego -i $< -o $@ $(STRINCLUDES)
