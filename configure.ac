AC_PREREQ([2.60])
AC_INIT([webdsl], [9.7], [webdsl@st.ewi.tudelft.nl])
AC_CONFIG_AUX_DIR([config])
AM_INIT_AUTOMAKE([1.7.2 -Wall -Wno-portability foreign])

m4_pattern_forbid([^(AB|XT)_])
m4_pattern_forbid([^PKG_CHECK_MODULES$])

# set prefix to the default prefix
test "x$prefix" = xNONE && prefix=$ac_default_prefix

### DEPENDENCIES ##################################

AC_PROG_INSTALL

AC_CHECK_PROG([bash], [bash], [`type -p bash`], [/bin/bash])

AM_CONDITIONAL(TEST_MACOSX, [test $(uname -s) = "Darwin"])
AM_CONDITIONAL(TEST_LINUX, [test $(uname -s) = "Linux"])
AM_CONDITIONAL(TEST_WINDOWS, [test $OS = "Windows_NT"])

### OUTPUT ########################################

AC_CONFIG_FILES([
Makefile
src/Makefile
test/Makefile
src/org/webdsl/dsl/project/testnewproject.sh
src/org/webdsl/dsl/project/webdsl
src/org/webdsl/dsl/project/webdsl-eclipseplugin
src/org/webdsl/dsl/project/webdsl-plugins
src/org/webdsl/dsl/project/Makefile
test/run
test/run-test-fail-servlet.sh
test/run-test-fail.sh
test/run-test-succeed-all-servlet.sh
test/run-test-succeed-all.sh
test/run-test-succeed-web-all.sh
test/generatenix.sh
],
[ chmod +x src/org/webdsl/dsl/project/testnewproject.sh
  chmod +x test/run
  chmod +x test/run-test-fail-servlet.sh
  chmod +x test/run-test-fail.sh
  chmod +x test/run-test-succeed-all-servlet.sh
  chmod +x test/run-test-succeed-all.sh
  chmod +x test/run-test-succeed-web-all.sh
  chmod +x test/generatenix.sh
])
AC_OUTPUT

