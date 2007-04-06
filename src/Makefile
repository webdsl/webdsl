
syntax = org/webdsl/dsl/syntax/WebDSL

generator = org/webdsl/dsl/generation/dsl-to-seam

STRINCLUDES = \
	-I . \
	-I $(HOME)/.nix-profile/share/java-front \
	-I $(HOME)/.nix-profile/share/sdf/xml-front \
        `pkg-config --variable=strcflags java-front` \

STRCFLAGS = \
	-la stratego-xtc \
    -la stratego-lib -la ${HOME}/.nix-profile/lib/libjava-front.la

all : $(syntax).def $(syntax).tbl $(syntax).rtg $(syntax).str $(generator)

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

% : %.str
	echo $(STRCFLAGS)
	strc -i $< -o $@ $(STRCFLAGS) $(STRINCLUDES)

%.str.pp : %.str
	pp-stratego -i $< -o $@ $(STRINCLUDES)
