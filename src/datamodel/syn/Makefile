all : DataModel.def DataModel.tbl DataModel.rtg DataModel.str

%.str : %.rtg
	rtg2str -i $< -o $@

%.def : %.sdf
	pack-sdf -i $< -o $@

%.tbl : %.def
	sdf2table -i $< -o $@
