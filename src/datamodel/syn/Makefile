all : DataModel.def DataModel.tbl DataModel.rtg DataModel.str

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

