AC_PREREQ([2.60])

AC_INIT([webdsl], [7.12], [webdsl@st.ewi.tudelft.nl])

AC_CONFIG_MACRO_DIR([config])
AC_CONFIG_AUX_DIR([config])

AM_INIT_AUTOMAKE([1.7.2 -Wall -Wno-portability])

m4_pattern_forbid([^(AB|XT)_])
m4_pattern_forbid([^PKG_CHECK_MODULES$])

# set prefix to the default prefix
test "x$prefix" = xNONE && prefix=$ac_default_prefix

### DEPENDENCIES ##################################

XT_SETUP

# comment to make this a stable release
XT_PRE_RELEASE

XT_USE_XT_PACKAGES
XT_USE_JAVA_FRONT

AC_PROG_CC
AC_PROG_INSTALL
PKG_PROG_PKG_CONFIG

# Comma-separated list of tools required for the build.
# The first argument will be used to add a --with-generic-tools-xtc=PATH to
# configure so that the user can specify the location of the XTC repository
# where these tools can be found. If this argument isn't provided, or if we
# can't find one of the tools in the XTC repository indicated, we will still
# search in $PATH before failing.
# Each tool will be saved in the make variable $(TOOL_NAME)
TFM_CHECK_PROG([generic-tools],
[attrsdf2sdf-detgen,
 gen-filters,
 detgen,
 parse-attrsdf-definition,
 attrsdf2table,
 attrsdf2sdf-detgen,
 pp-attrsdf,
 pack-esdf,
 rename,
 sdf-strip,
 boxed-desugar,
 boxed2pp-table,
 str-concrete,
 sdf-option,
 sdf-astgen])

# Same thing but finds the files given in the 3rd argument (comma separated
# list of files) and builds the propers -I's to use in the make variable
# $(TOOL_NAME_INCLUDES) (tool-name being the 2nd argument).
TFM_CHECK_INCLUDES([generic-tools], [sdf-attribute],
                   [AttrSdf.str, AttrSdf.sdf])
TFM_CHECK_INCLUDES([generic-tools], [str-lazy], [lazy.str, liblazy.rtree])

# Same thing but this time it saves in the full path to the libraries passed in
# 3rd argument in the make variable $(TOOL_NAME_LIBS)
TFM_CHECK_LIBS([generic-tools], [str-lazy],
               [lazy-lib, lazy-lib-native])


### OUTPUT ########################################

AC_CONFIG_FILES([
Makefile
src/Makefile
src/org/webdsl/dsl/generation/Makefile
src/org/webdsl/dsl/project/webdsl
src/org/webdsl/dsl/project/Makefile
webdsls.pc
])
AC_OUTPUT
