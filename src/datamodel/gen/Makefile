all : datamodel-to-hbm

STRCFLAGS = -I ../syn \
	    -I $(HOME)/.nix-profile/share/sdf/java-front \
	    -I $(HOME)/.nix-profile/share/java-front \
	    -la stratego-lib 

datamodel-to-hbm : datamodel-to-hbm.str
	strc -i datamodel-to-hbm.str -o datamodel-to-hbm $(STRCFLAGS)