AC_PREREQ([2.60])
AC_INIT([webdsl], [8.3], [webdsl@st.ewi.tudelft.nl])
AC_CONFIG_AUX_DIR([config])
AM_INIT_AUTOMAKE([1.7.2 -Wall -Wno-portability])

m4_pattern_forbid([^(AB|XT)_])
m4_pattern_forbid([^PKG_CHECK_MODULES$])

# set prefix to the default prefix
test "x$prefix" = xNONE && prefix=$ac_default_prefix

### DEPENDENCIES ##################################

XT_SETUP
#XT_USE_BOOTSTRAP_XT_PACKAGES

# comment to make this a stable release
XT_PRE_RELEASE

XT_USE_XT_PACKAGES
XT_USE_JAVA_FRONT

AC_PROG_CC
AC_PROG_INSTALL
PKG_PROG_PKG_CONFIG

AC_DISABLE_STATIC
AC_PROG_LIBTOOL

### OUTPUT ########################################

AC_CONFIG_FILES([
Makefile
src/Makefile
src/org/webdsl/dsl/project/webdsl
src/org/webdsl/dsl/project/webdsl-plugins
src/org/webdsl/dsl/project/Makefile
webdsls.pc
])
AC_OUTPUT
