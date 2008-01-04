LIBS = -I ~/.nix-profile/share/java-front/ -I ~/.nix-profile/share/java-front-syntax -la stratego-lib -la ~/.nix-profile/lib/libjava-front.la

main:
	strc -i merge.str $(LIBS)

clean:
	rm -f *.o *.dep *.lo *.c merge