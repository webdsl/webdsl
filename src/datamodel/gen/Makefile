all : datamodel-to-hbm

STRCFLAGS = -I ../syn \
	    -I $(HOME)/.nix-profile/share/sdf/java-front \
	    -I $(HOME)/.nix-profile/share/java-front \
            `pkg-config --variable=strcxtcflags java-front` \
            -la stratego-xtc \
            -la stratego-lib -la ${HOME}/.nix-profile/lib/libjava-front.la


datamodel-to-hbm : datamodel-to-hbm.str
	echo $(STRCFLAGS)
	strc -i datamodel-to-hbm.str -o datamodel-to-hbm $(STRCFLAGS)