# General make-rules. Transformers.mk is part of Transformers.
# Copyright (C) 2004, 2005, 2006  EPITA Research and Development Laboratory.
#
# Transformers is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301,
# USA.

# -*-Makefile-*-

include $(top_srcdir)/config/Makefile.xt

SUFFIXES += .esdf .pp .edef .edef.af .def.af .edef-fast .edef-fast.af .rtg
SUFFIXES += .edef-ag-af .edef-ag .etbl-ag .full-ag

$(AG_GRM:.ag=.pp): $(AG_GRM:.ag=.edef-fast.af)
	$(BOXED2PP_TABLE) -i $< \
	| $(SDF_TOOLS)/bin/pp-pp-table -o $@

.def.af.def:
	$(SDF_FRONT)/libexec/sdf-desugar -i $< \
	| $(GPP)/bin/pp-sdf -o $@

.edef-ag.rtg:
	$(GPP)/bin/pp-sdf -i "$<" \
	| $(STRATEGO_REGULAR)/bin/sdf2rtg $(SDF2RTG_FLAGS) -o "$@"


###########################################################
#
# Makerules for creating table and evaluator from AG grammar.
#
# Some rules overlaps with standard ones, thus there are not
# always default targets available.
# Instead, you have to define the variable AC_GRM when using AG.
#

%.edef-fast.af: %.esdf $(SDFS)
	$(PACK_ESDF) \
		-of ast \
		-s AttrSdf \
		$(SDF_ATTRIBUTE_INCLUDES) \
		-i $< -o $@

# FIXME: should be handled by esdf
.edef-fast.af.edef:
	$(PP_ATTRSDF) -i $< -o $@

# Remove meta-code
.edef.edef-ag-af:
	$(ATTRSDF2TABLE) $(PGEN_FLAGS) --desugar -i $< -o $@ \
          $(ATTRSDF2TABLE_FLAGS)

# Remove meta-code
.edef-ag-af.edef-ag:
	$(ATTRSDF2TABLE) $(PGEN_FLAGS) --def-ag -i $< -o $@ \
          $(ATTRSDF2TABLE_FLAGS)

# Intermediate step
.edef-ag.tbl-ag:
	$(ATTRSDF2TABLE) $(PGEN_FLAGS) --tbl-ag -i $< -o $@ \
          $(ATTRSDF2TABLE_FLAGS)

# Remove useless productions and propagate attributes.
.tbl-ag.full-ag:
	$(ATTRSDF2TABLE) $(PGEN_FLAGS) --full-ag -i $< -o $@ \
          $(ATTRSDF2TABLE_FLAGS)

# Create the evaluator code
$(AG_PATH)eval-$(AG_GRM:.ag=.str): $(AG_PATH)$(AG_GRM:.ag=.full-ag)
	$(ATTRSDF2TABLE) $(PGEN_FLAGS) --eval-ag -i $< -o $@ \
          $(ATTRSDF2TABLE_FLAGS)

# In other Makefiles, %.tbl is dependant to %.def
# Create the parse table
.tbl-ag.tbl:
	$(ATTRSDF2TABLE) $(PGEN_FLAGS) --sglr-tbl -i $< -o $@ \
          $(ATTRSDF2TABLE_FLAGS)

%.def.af: %.edef-ag-af
	$(SDF_STRIP) -i $< -o $@

# eval-foo.c depends on foo.str and eval-foo.str
$(AG_PATH)eval-$(AG_GRM:.ag=.c): $(AG_PATH)$(AG_GRM:.ag=.str) $(AG_PATH)eval-$(AG_GRM:.ag=.str)

## --------------- ##
## Building TAGS.  ##
## --------------- ##

TAGS_FILES = $(wildcard *.str)

ETAGS_ARGS = $(ETAGS_FOR_STRATEGO)

ETAGS_FOR_STRATEGO = \
  --lang=none \
  --regex='/^[ \t]*\([-a-zA-Z_][-a-zA-Z_]*\)[ \t]*[:=]\(\|[^+>\-].*\)$$/\1/'

tags-recursive:
	list='$(SUBDIRS) .'; for subdir in $$list; do \
	  test "$$subdir" = . || (cd $$subdir && $(MAKE) $(AM_MAKEFLAGS) tags); \
	done

# We override automake's own tags rules because it always includes
# generated C files, which we don't want. Unfortunately this will
# trigger warnings.
TAGS: tags-recursive $(TAGS_DEPENDENCIES) $(TAGS_FILES)
	tags=; \
	here=`pwd`; \
	if ($(ETAGS) --etags-include --version) >/dev/null 2>&1; then \
	  include_option=--etags-include; \
	  empty_fix=.; \
	else \
	  include_option=--include; \
	  empty_fix=; \
	fi; \
	list='$(SUBDIRS)'; for subdir in $$list; do \
	  if test "$$subdir" = .; then :; else \
	    test ! -f $$subdir/TAGS || \
	      tags="$$tags $$include_option=$$here/$$subdir/TAGS"; \
	  fi; \
	done; \
	list='$(TAGS_FILES)'; \
	unique=`for i in $$list; do \
	    if test -f "$$i"; then echo $$i; else echo $(srcdir)/$$i; fi; \
	  done | \
	  $(AWK) '    { files[$$0] = 1; } \
	       END { for (i in files) print i; }'`; \
	if test -z "$$tags$$unique"; then :; else \
	  test -n "$$unique" || unique=$$empty_fix; \
	  $(ETAGS) $(ETAGSFLAGS) $(AM_ETAGSFLAGS) $(ETAGS_ARGS) \
	    $$tags $$unique; \
	fi
