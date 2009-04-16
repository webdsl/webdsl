all: pp2c javapp2c

pp2c:
	strc \
	--main pp2c \
	-i pp2c.str \
	-o pp2c \
	-la stratego-lib \
	-la stratego-xtc \
	--xtc-repo ~/.nix-profile/share/strategoxt/XTC
	
javapp2c:
	./pp2c \
	-i Java-15.pp \
	-p Java-15.def \
	-n pp_java_0_0 \
	-o java-pp.c	
	
make deploy: all
	cp java-pp.c ../src/	

clean:
	rm -r \
	pp2c.c \
	pp2c.o \
	pp2c.lo \
	pp2c \
	pp2c.dep \
	.libs \
	java-pp.c