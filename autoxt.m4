#     							-*- Autoconf -*-
# serial 3
#
# Author: Eelco Visser <visser@cs.uu.nl>
#
# This Autoconf macro file provides parameters for a package that is built
# with the XT bundle of program transformation tools.
# The macros are organized hierarchically such that packages that are included
# in a larger bundle do not need to be provided explicitly.

# XT_ left in configure is the sign a macro was not defined, or there was a typo
# in a macro invocation.
m4_pattern_forbid([^XT_])

# XT_SETUP
# --------
# Invokes all macros that always need to be invoked for an XT package.
AC_DEFUN([XT_SETUP],
[
  AC_REQUIRE([XT_DARWIN])
  AC_REQUIRE([XT_CHECK_LINKING])
  AC_REQUIRE([XT_STRICT_ISO_C99])
  AC_REQUIRE([XT_C_TYPE_CHARACTERISTICS])

  AC_SUBST([STR_CFLAGS])
  AC_SUBST([STR_LDFLAGS])
])

# XT_DARWIN
# ---------
# Sets some additional linker flags that are required on Darwin (Mac OS X)
AC_DEFUN([XT_DARWIN],
[
  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([AC_CANONICAL_BUILD])

  # As an exception to XT_* macros name, this is a valid part of configure.
  m4_pattern_allow([^XT_DARWIN(_TRUE|_FALSE)?$])

  AC_MSG_CHECKING([whether host operating system is Darwin])
  xt_darwin="no"
  case $host_os in
    darwin*)
      xt_darwin="yes"
      ;;
  esac
  AC_MSG_RESULT([$xt_darwin])
  AM_CONDITIONAL([XT_DARWIN], [test "$xt_darwin" = "yes"])
])

# XT_C_TYPE_CHARACTERISTICS
# -----------------
AC_DEFUN([XT_C_TYPE_CHARACTERISTICS],
[
  AC_CHECK_SIZEOF([void *])
  AC_CHECK_SIZEOF([int])
  AC_CHECK_SIZEOF([long])
  AC_CHECK_SIZEOF([double])
])

# XT_STRICT_ISO_C99
# -----------------
AC_DEFUN([XT_STRICT_ISO_C99],
[
  AC_REQUIRE([AC_PROG_CC])

  if test "x$GCC" = "xyes"; then
    STR_CFLAGS="${STR_CFLAGS} -Wall -Wno-unused-label -Wno-unused-variable -Wno-unused-function -Wno-unused-parameter"
  fi

  # -Werror
  AC_ARG_ENABLE([werror],
    [AS_HELP_STRING([--enable-werror],[compile C sources using -Werror @<:@default=no@:>@])],
    [enable_werror=yes],
    [])

  if test "x$enable_werror" = "xyes"; then
    STR_CFLAGS="${STR_CFLAGS} -Werror"
  fi

  # Standards
  AC_MSG_CHECKING([for the standard to conform to])
  AC_ARG_WITH([std],
    [AS_HELP_STRING([--with-std={C99|POSIX|POSIX+XSI}],[standard to conform to @<:@default=none@:>@])],
    [xt_std_arg=$withval],
    [])

  if test "${xt_std_arg:+set}" = set; then
    xt_std="${xt_std_arg}"
  else
    xt_std="none"
    # TODO: if not specified, then maybe be conservative on platforms with known problems (WIN32 etc)
  fi

  if test "x${xt_std}" = "xC99"; then
    xt_std="C99"
    STR_CFLAGS="${STR_CFLAGS} -DXT_STD_DISABLE_POSIX -DXT_STD_DISABLE_POSIX_XSI"
    if test "x$GCC" = "xyes"; then
      STR_CFLAGS="${STR_CFLAGS} -std=c99 -pedantic"
    fi
  else
    if test "x${xt_std}" = "xPOSIX"; then
      xt_std="POSIX"
      STR_CFLAGS="${STR_CFLAGS} -D_POSIX_C_SOURCE=200112L -DXT_STD_DISABLE_POSIX_XSI"
    else
      if test "x${xt_std}" = "xPOSIX+XSI"; then
        xt_std="POSIX+XSI"
        STR_CFLAGS="${STR_CFLAGS} -D_XOPEN_SOURCE=600"
      else
        if test "x${xt_std}" != "xnone"; then
          AC_MSG_ERROR([illegal value for option --with-std. Please use C99, POSIX, or POSIX+XSI])
        fi
      fi
    fi
  fi
  AC_MSG_RESULT([$xt_std])

  m4_pattern_allow([^XT_STD_C99(_TRUE|_FALSE)?$])
  m4_pattern_allow([^XT_STD_POSIX(_TRUE|_FALSE)?$])
  m4_pattern_allow([^XT_STD_POSIX_XSI(_TRUE|_FALSE)?$])
  m4_pattern_allow([^XT_STD_NONE(_TRUE|_FALSE)?$])

  AM_CONDITIONAL([XT_STD_C99], [test "$xt_std" = "C99"])
  AM_CONDITIONAL([XT_STD_POSIX], [test "$xt_std" = "POSIX"])
  AM_CONDITIONAL([XT_STD_POSIX_XSI], [test "$xt_std" = "POSIX+XSI"])
  AM_CONDITIONAL([XT_STD_NONE], [test "$xt_std" = "none"])
])

# XT_CHECK_LINKING
# ---------
# Figure out how to link Stratego programs. This should actually be checked, but
# the error is difficult to reproduce.
AC_DEFUN([XT_CHECK_LINKING],
[
  AC_REQUIRE([XT_DARWIN])

  AC_MSG_CHECKING([if linker needs extra options for Stratego programs])
  if test "$xt_darwin" = "yes"; then
    STR_LDFLAGS="${STR_LDFLAGS} -bind_at_load"
    AC_MSG_RESULT([yes, using -bind_at_load])
  else
    AC_MSG_RESULT([no])
  fi
])

############################################## FIND AND CHECK PACKAGES ##############################

# XT_CHECK_ATERM
# --------------
# Check for the ATerm library.
AC_DEFUN([XT_CHECK_ATERM],
[
  AC_ARG_WITH([aterm],
    [AS_HELP_STRING([--with-aterm=DIR], [use ATerm Library at DIR @<:@find with pkg-config@:>@])],
    [ATERM=$withval])

  AC_MSG_CHECKING([whether location of ATerm library is explicitly set])
  if test "${ATERM:+set}" = set; then
    AC_MSG_RESULT([yes])

    # Check the specified value of $ATERM
    XT_PKG_ATERM
    AC_SUBST([ATERM])
    AC_SUBST([ATERM_CFLAGS], ['-I$(ATERM)/include'])
    AC_SUBST([ATERM_LIBS], ['-L$(ATERM)/lib -lATerm -lm'])
  else
    AC_MSG_RESULT([no])
    # Try to find the aterm library using pkgconfig.
    XT_CHECK_PACKAGE([ATERM],[aterm >= 2.5],[lib/libATerm.a])
  fi
])

# XT_CHECK_SDF
# ------------
AC_DEFUN([XT_CHECK_SDF],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_ARG_WITH([sdf],
    [AS_HELP_STRING([--with-sdf=DIR], [use SDF Packages at DIR @<:@find with pkg-config@:>@])],
    [SDF=$withval])

  AC_MSG_CHECKING([whether location of SDF Packages is explicitly set])
  if test "${SDF:+set}" = set; then
    AC_MSG_RESULT([yes])

    # Check the specified value of $SDF
    XT_PKG_SDF
    AC_SUBST([SDF])
  else
    AC_MSG_RESULT([no])
    # Try to find the SDF Packages using pkgconfig.
    XT_CHECK_PACKAGE([SDF],[sdf2-bundle >= 2.4],[bin/sglr$EXEEXT])
  fi

  AC_SUBST([SGLR], ['$(SDF)'])
  AC_SUBST([PGEN], ['$(SDF)'])
  AC_SUBST([PT_SUPPORT], ['$(SDF)'])
  AC_SUBST([SDF_LIBRARY], ['$(SDF)'])

  # backward compatibitily
  AC_SUBST([ASF_LIBRARY], ['$(SDF)'])
])

# XT_WITH_STRATEGOXT_ARG
# ----------------------
AC_DEFUN([XT_WITH_STRATEGOXT_ARG],
[
  AC_ARG_WITH([strategoxt],
    [AS_HELP_STRING([--with-strategoxt=DIR], [use Stratego/XT at DIR @<:@find with pkg-config@:>@])],
    [STRATEGOXT=$withval])
])

# XT_WITH_STRATEGO_LIBRARIES_ARG
# ------------------------------
AC_DEFUN([XT_WITH_STRATEGO_LIBRARIES_ARG],
[
  AC_ARG_WITH([stratego-libraries],
    [AS_HELP_STRING([--with-stratego-libraries=DIR], [use Stratego Libraries at DIR @<:@find with pkg-config@:>@])],
    [STRATEGO_LIBRARIES=$withval])
])

# XT_WITH_XTC_ARG
# ------------------------------
AC_DEFUN([XT_WITH_XTC_ARG],
[
  AC_ARG_WITH([xtc],
    [AS_HELP_STRING([--with-xtc=DIR], [use XTC at DIR @<:@Stratego/XT or find with pkg-config@:>@])],
    [XTC=$withval])
])

# XT_CHECK_XTC
# ------------
AC_DEFUN([XT_CHECK_XTC],
[
  AC_REQUIRE([XT_WITH_STRATEGOXT_ARG])
  AC_REQUIRE([XT_WITH_XTC_ARG])

  AC_MSG_CHECKING([whether location of XTC package is explicitly set])
  if test "${XTC:+set}" = set; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
  fi

  # Try value of --with-strategoxt
  AC_MSG_CHECKING([whether location of XTC package is set explicity by the location of Stratego/XT])
  if test "${STRATEGOXT:+set}" = set; then
    AC_MSG_RESULT([yes])
    XTC=$STRATEGOXT
  else
    AC_MSG_RESULT([no])
  fi

  if test "${XTC:+set}" = set; then
    AC_SUBST([XTC])
    AC_SUBST([XTC_PROG], ['$(XTC)/bin/xtc'])
  else
    # Try to find XTC using pkgconfig.
    # We are not using a witness here, since xtc might not be installed yet
    # if this macro is used in Stratego/XT itself.
    XT_CHECK_PACKAGE([XTC],[xtc])

    AC_MSG_CHECKING([for location of xtc program])
    XTC_PROG="$($PKG_CONFIG --variable=xtc xtc)"
    if test -z "$XTC_PROG"; then
      AC_MSG_RESULT([not found])
      AC_MSG_ERROR([xtc module does not define xtc variable])
    else
      AC_MSG_RESULT([$XTC_PROG])
      AC_SUBST([XTC_PROG])
    fi
  fi

  if test "${xt_xtc_register:-set}" = set; then
    xt_xtc_register="yes"
  fi

  AM_CONDITIONAL([XT_XTC_REGISTER], [test "$xt_xtc_register" = "yes"])
])

m4_pattern_allow([^XT_XTC_REGISTER(_TRUE|_FALSE)?$])

# XT_DISABLE_XTC_REGISTER
# -----------------------
AC_DEFUN([XT_DISABLE_XTC_REGISTER],
[
  xt_xtc_register="no"
  AM_CONDITIONAL([XT_XTC_REGISTER], [test "yes" = "no"])
])

# XT_ENABLE_XTC_REGISTER
# -----------------------
AC_DEFUN([XT_ENABLE_XTC_REGISTER],
[ 
  xt_xtc_register="yes"
  AM_CONDITIONAL([XT_XTC_REGISTER], [test "yes" = "yes"])
])

# XT_WITH_XTC_ARGS
# ----------------
# Arguments for XTC repositories.
AC_DEFUN([XT_WITH_XTC_ARGS],
[
  BUILDTIME_XTC="BUILDTIME_XTC"

  XT_ARG_WITH2([repository],      [datadir/$PACKAGE/XTC],
               [FILE], [XTC Repository])
  XT_ARG_WITH2([build-repository],[BUILDTIME_XTC],
               [FILE], [Build-time XTC Repository])

  # Make sure BUILD_REPOSITORY is an absolute path.
  case $BUILD_REPOSITORY in
    [[\\/]]* ) ;;
    *) BUILD_REPOSITORY=`pwd`/$BUILD_REPOSITORY ;;
  esac

])

# XT_CHECK_STRATEGO_LIBRARIES
# ---------------------------
AC_DEFUN([XT_CHECK_STRATEGO_LIBRARIES],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([XT_SETUP])
  AC_REQUIRE([XT_WITH_STRATEGO_LIBRARIES_ARG])
  AC_REQUIRE([XT_WITH_STRATEGOXT_ARG])

  AC_MSG_CHECKING([whether location of Stratego Libraries is explicitly set])
  if test "${STRATEGO_LIBRARIES:+set}" = set; then
    AC_MSG_RESULT([yes])
    XT_HANDLE_EXPLICIT_STRATEGO_LIBRARIES
  else
    if test "${STRATEGOXT:+set}" = set; then
      AC_MSG_RESULT([yes, using --with-strategoxt])
      STRATEGO_LIBRARIES="$STRATEGOXT"
      XT_HANDLE_EXPLICIT_STRATEGO_LIBRARIES
    else
      AC_MSG_RESULT([no])

      XT_CHECK_PACKAGE([STRATEGO_RUNTIME],[stratego-runtime])
      XT_CHECK_PACKAGE([STRATEGO_LIB],[stratego-lib])
      XT_CHECK_PACKAGE([STRATEGO_XTC],[stratego-xtc])
      XT_CHECK_PACKAGE([STRATEGO_SGLR],[stratego-sglr])
      XT_CHECK_PACKAGE([STRATEGO_GPP],[stratego-gpp])
      XT_CHECK_PACKAGE([STRATEGO_SDF],[stratego-sdf])
      XT_CHECK_PACKAGE([STRATEGO_RTG],[stratego-rtg])
      XT_CHECK_PACKAGE([STRATEGO_TOOL_DOC],[stratego-tool-doc])
      XT_CHECK_PACKAGE([STRATEGO_ATERM],[stratego-aterm])
    fi
  fi

  # backward compatibitily
  AC_SUBST([SRTS], ['$(STRATEGO_RUNTIME)'])
  AC_SUBST([XTC_LIBS], ['$(STRATEGO_XTC_LIBS)'])
  AC_SUBST([XTC_STRCFLAGS], ['$(STRATEGO_XTC_STRCFLAGS)'])
])

# XT_CHECK_STRATEGOXT
# ----------------------------
AC_DEFUN([XT_CHECK_STRATEGOXT],
[
  AC_REQUIRE([AC_PROG_CC])
  AC_REQUIRE([XT_WITH_STRATEGOXT_ARG])
  
  XT_CHECK_STRATEGO_LIBRARIES
  XT_CHECK_XTC

  AC_MSG_CHECKING([whether location of Stratego/XT is explicitly set])
  if test "${STRATEGOXT:+set}" = set; then
    AC_MSG_RESULT([yes])
    XT_HANDLE_EXPLICIT_STRATEGOXT

  else
    AC_MSG_RESULT([no])

    # Try to find the Stratego/XT Packages using pkgconfig.
    XT_CHECK_PACKAGE([STRATEGOXT],[strategoxt],[bin/strc$EXEEXT])
    XT_CHECK_PACKAGE([C_TOOLS],[c-tools])
  fi

  # These packages need pkg-config files.
  AC_SUBST([STRC], ['$(STRATEGOXT)'])
  AC_SUBST([GPP], ['$(STRATEGOXT)'])
  AC_SUBST([STRATEGO_FRONT], ['$(STRATEGOXT)'])
  AC_SUBST([ASFIX_TOOLS], ['$(STRATEGOXT)'])
  AC_SUBST([ATERM_FRONT], ['$(STRATEGOXT)'])
  AC_SUBST([SDF_FRONT], ['$(STRATEGOXT)'])
  AC_SUBST([SDF_TOOLS], ['$(STRATEGOXT)'])
  AC_SUBST([CONCRETE_SYNTAX], ['$(STRATEGOXT)'])
  AC_SUBST([XML_FRONT], ['$(STRATEGOXT)'])
  AC_SUBST([STRATEGO_REGULAR], ['$(STRATEGOXT)'])
  if test "x$SCOMPILE" = x; then
    SCOMPILE='$(STRC)/bin/strc'
  fi
  AC_SUBST([SCOMPILE])
])

# XT_HANDLE_EXPLICIT_STRATEGO_LIBRARIES
# -----------------------------
# Don't invoke directly.
# This macro is also used internally (see internal-autoxt.m4)
AC_DEFUN([XT_HANDLE_EXPLICIT_STRATEGO_LIBRARIES],
[
  AC_SUBST([STRATEGO_LIBRARIES])

  AC_SUBST([STRATEGO_RUNTIME], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_RUNTIME_CFLAGS], ['-I$(STRATEGO_RUNTIME)/include'])
  AC_SUBST([STRATEGO_RUNTIME_LIBS], ['-L$(STRATEGO_RUNTIME)/lib -lstratego-runtime -lm'])

  AC_SUBST([STRATEGO_LIB], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_LIB_CFLAGS], ['-I$(STRATEGO_LIB)/include -I$(STRATEGO_RUNTIME)/include -I$(ATERM)/include'])
  AC_SUBST([STRATEGO_LIB_LIBS], ['-L$(STRATEGO_LIB)/lib -lstratego-lib -lstratego-lib-native -lm'])
  AC_SUBST([STRATEGO_LIB_STRCFLAGS], ['-I $(STRATEGO_LIB)/share/stratego-lib'])

  AC_SUBST([STRATEGO_XTC], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_XTC_CFLAGS], [''])
  AC_SUBST([STRATEGO_XTC_LIBS], ['-L$(STRATEGO_XTC)/lib -lstratego-xtc'])
  AC_SUBST([STRATEGO_XTC_STRCFLAGS], ['-I $(STRATEGO_XTC)/share'])

  AC_SUBST([STRATEGO_SGLR], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_SGLR_CFLAGS], [''])
  AC_SUBST([STRATEGO_SGLR_LIBS], ['-L$(STRATEGO_SGLR)/lib -lstratego-sglr'])
  AC_SUBST([STRATEGO_SGLR_STRCFLAGS], ['-I $(STRATEGO_SGLR)/share'])

  AC_SUBST([STRATEGO_GPP], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_GPP_CFLAGS], [''])
  AC_SUBST([STRATEGO_GPP_LIBS], ['-L$(STRATEGO_GPP)/lib -lstratego-gpp'])
  AC_SUBST([STRATEGO_GPP_STRCFLAGS], ['-I $(STRATEGO_GPP)/share'])

  AC_SUBST([STRATEGO_SDF], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_SDF_CFLAGS], [''])
  AC_SUBST([STRATEGO_SDF_LIBS], ['-L$(STRATEGO_SDF)/lib -lstratego-sdf'])
  AC_SUBST([STRATEGO_SDF_STRCFLAGS], ['-I $(STRATEGO_SDF)/share'])

  AC_SUBST([STRATEGO_RTG], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_RTG_CFLAGS], [''])
  AC_SUBST([STRATEGO_RTG_LIBS], ['-L$(STRATEGO_RTG)/lib -lstratego-rtg'])
  AC_SUBST([STRATEGO_RTG_STRCFLAGS], ['-I $(STRATEGO_RTG)/share'])

  AC_SUBST([STRATEGO_TOOL_DOC], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_TOOL_DOC_CFLAGS], [''])
  AC_SUBST([STRATEGO_TOOL_DOC_LIBS], ['-L$(STRATEGO_TOOL_DOC)/lib -lstratego-tool-doc'])
  AC_SUBST([STRATEGO_TOOL_DOC_STRCFLAGS], ['-I $(STRATEGO_TOOL_DOC)/share'])

  AC_SUBST([STRATEGO_ATERM], ['$(STRATEGO_LIBRARIES)'])
  AC_SUBST([STRATEGO_ATERM_CFLAGS], [''])
  AC_SUBST([STRATEGO_ATERM_LIBS], ['-L$(STRATEGO_ATERM)/lib -lstratego-aterm'])
  AC_SUBST([STRATEGO_ATERM_STRCFLAGS], ['-I $(STRATEGO_ATERM)/share'])
])

# XT_HANDLE_EXPLICIT_STRATEGOXT
# -----------------------------
# Don't invoke directly.
# This macro is also used internally (see internal-autoxt.m4)
AC_DEFUN([XT_HANDLE_EXPLICIT_STRATEGOXT],
[
  # Check the specified value of $STRATEGOXT
  XT_PKG_STRATEGOXT
  AC_SUBST([STRATEGOXT])
  AC_SUBST([XTC], ['$(STRATEGOXT)'])
  AC_SUBST([C_TOOLS], ['$(STRATEGOXT)'])
  AC_SUBST([STRATEGOXT_XTC], ['$(STRATEGOXT)/share/strategoxt/XTC'])
])

# XT_CHECK_STRATEGOXT_UTILS
# -------------------------
AC_DEFUN([XT_CHECK_STRATEGOXT_UTILS],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_ARG_WITH([strategoxt-utils],
    [AS_HELP_STRING([--with-strategoxt-utils=DIR], [use Stratego/XT Utilities at DIR @<:@find with pkg-config@:>@])],
    [STRATEGOXT_UTILS=$withval])

  AC_MSG_CHECKING([whether location of Stratego/XT Utilities is explicitly set])
  if test "${STRATEGOXT_UTILS:+set}" = set; then
    AC_MSG_RESULT([yes])

    # Check the specified value of $STRATEGOXT_UTILS
    XT_PKG_STRATEGOXT_UTILS

    AC_SUBST([STRATEGOXT_UTILS])
    AC_SUBST([STRATEGOXT_UTILS_XTC], ['$(STRATEGOXT_UTILS)/share/strategoxt-utils/XTC'])
  else
    AC_MSG_RESULT([no])

    # Try to find the Stratego/XT Utilities using pkgconfig.
    XT_CHECK_PACKAGE([STRATEGOXT_UTILS],[strategoxt-utils],[bin/pp-dot$EXEEXT])
  fi

  # backward compatibitily
  AC_SUBST([DOT_TOOLS], ['$(STRATEGOXT_UTILS)'])
])

# XT_CHECK_PACKAGES
# -----------------
AC_DEFUN([XT_CHECK_PACKAGES],
[
  AC_REQUIRE([XT_CHECK_ATERM])
  AC_REQUIRE([XT_CHECK_SDF])
  AC_REQUIRE([XT_CHECK_STRATEGOXT])
])

# XT_USE_XT_PACKAGES
# ------------------
AC_DEFUN([XT_USE_XT_PACKAGES],
[
  AC_REQUIRE([XT_SETUP])
  AC_REQUIRE([XT_CHECK_PACKAGES])
  AC_REQUIRE([XT_WITH_XTC_ARGS])
])

m4_pattern_allow([^XT_BOOTSTRAP(_TRUE|_FALSE)?$])

# XT_USE_BOOTSTRAP_XT_PACKAGES
# ----------------------------
AC_DEFUN([XT_USE_BOOTSTRAP_XT_PACKAGES],
[
  AC_REQUIRE([XT_SETUP])
  AC_REQUIRE([XT_WITH_STRATEGOXT_ARG])
  AC_REQUIRE([XT_WITH_XTC_ARG])

  AC_ARG_ENABLE([bootstrap],
    [AS_HELP_STRING([--enable-bootstrap], [Enable a bootstrap build (requires Stratego/XT) @<:@default=no@:>@])],
    [xt_bootstrap="$enableval"])

  AC_ARG_ENABLE([xtc],
    [AS_HELP_STRING([--enable-xtc], [Enable XTC registration @<:@default=no@:>@])],
    [xt_xtc_register="$enableval"])
  
  # If Stratego/XT is given, then enable bootstrap and XTC register
  AC_MSG_CHECKING([whether location of Stratego/XT is explicitly set])
  if test "${STRATEGOXT:+set}" = set; then
    AC_MSG_RESULT([yes])
    if test "${xt_bootstrap:-set}" = set; then
      xt_bootstrap="yes"
    fi
    if test "${xt_xtc_register:-set}" = set; then
      xt_xtc_register="yes"
    fi
  else
    AC_MSG_RESULT([no])
    if test "${xt_bootstrap:-set}" = set; then
      xt_bootstrap="no"
    fi
  fi

  # If XTC is given, then enable XTC register
  AC_MSG_CHECKING([whether location of XTC is explicitly set])
  if test "${XTC:+set}" = set; then
    AC_MSG_RESULT([yes])
    if test "${xt_xtc_register:-set}" = set; then
      xt_xtc_register="yes"
    fi
  else
    AC_MSG_RESULT([no])
  fi

  AM_CONDITIONAL([XT_BOOTSTRAP], [test "$xt_bootstrap" = "yes"])
  AC_MSG_CHECKING([whether bootstrap build is enabled])
  if test "$xt_bootstrap" = "yes"; then
    AC_MSG_RESULT([yes])
    XT_CHECK_ATERM
    XT_CHECK_SDF
    XT_CHECK_STRATEGOXT
    XT_WITH_XTC_ARGS
  else
    AC_MSG_RESULT([no])

    XT_CHECK_ATERM
    XT_CHECK_STRATEGO_LIBRARIES 

    AM_CONDITIONAL([XT_XTC_REGISTER], [test "$xt_xtc_register" = "yes"])
    if test "${xt_xtc_register}" = "yes"; then
      XT_CHECK_XTC
      XT_WITH_XTC_ARGS
    fi
  fi
])

################################### OBSOLETE MACROS ###################################

AU_DEFUN([USE_XT_PACKAGES], [XT_USE_XT_PACKAGES])
AU_DEFUN([XT_EXPLICITLY_USE_XT_PACKAGES][XT_USE_XT_PACKAGES])
AU_DEFUN([DETECT_SVN_REVISION], [XT_SVN_REVISION])

################################### GENERIC MACROS ####################################

# XT_ARG_WITH(OPTION, VAR, DEFAULT, ARGNAME, NAME)
# ------------------------------------------------
# Declaring the option --with-OPTION=ARGNAME to specify the location of the package NAME.
# Store the result in VAR, defaulting to $DEFAULT (note the $).
AC_DEFUN([XT_ARG_WITH],
[AC_ARG_WITH([$1],
             [AS_HELP_STRING([--with-$1=$4], [use $5 at $4 @<:@$3@:>@])],
	     [$2=$withval],
	     [$2=$$3])
AC_SUBST([$2])
])

# XT_ARG_WITH2(OPTION, DEFAULT, ARGNAME, NAME, [WITNESS])
# ------------------------------------------------------
# The name XT_ARG_WITH2 is temporary.
#
# Declaring the option --with-OPTION=ARGNAME to specify the location of
# the package NAME.
#
# Store the result in the variable which name is OPTION upper cased,
# using underscore for non letters.  $DEFAULT (note the $) is its
# default value.
#
# If the WITNESS is specified, make sure the file $VAR/WITNESS exists.
AC_DEFUN([XT_ARG_WITH2],
[m4_pushdef([AC_Var], AS_TR_CPP([$1]))dnl
AC_ARG_WITH([$1],
            [AS_HELP_STRING([--with-$1=$3], [use $4 at $3 @<:@$2@:>@])],
	    [AC_Var=$withval],
	    [AC_Var=$$2])
AC_SUBST(AC_Var)dnl
m4_ifval([$5],
[test -f "$AC_Var/$5" ||
  AC_MSG_ERROR([no such file: $AC_Var/$5
        Check the value of AC_Var (--with-$1)])
])dnl
m4_popdef([AC_Var])dnl
])

# XT_CHECK_PACKAGE(VARIABLE,MODULE,[WITNESS])
#
# Checks the existance of package 'MODULE' and sets the 
# variables VARIABLE, VARIABLE_STRCFLAGS, VARIABLE_XTC, VARIABLE_CFLAFS, and VARIABLE_LIBS.
#
# The optional WITNESS checks if the package is indeed 
# installed at the location where the pkg-config file says it 
# is installed.
#
# ------------------
AC_DEFUN([XT_CHECK_PACKAGE],
[AC_ARG_VAR([$1][_STRCFLAGS], [Stratego compiler flags for $1, overriding pkg-config])dnl
 AC_ARG_VAR([$1][_XTC], [XTC Repository for $1, overriding pkg-config])dnl
  PKG_CHECK_MODULES([$1],[$2])

  AC_MSG_CHECKING([for $1[]_STRCFLAGS])
  if test "${$1[]_STRCFLAGS:+set}" = set; then
    AC_MSG_RESULT([explicitly set: $$1[]_STRCFLAGS])
  else
    $1[]_STRCFLAGS=`$PKG_CONFIG --variable=strcflags "$2"`
    AC_MSG_RESULT([$$1[]_STRCFLAGS])
  fi

  AC_MSG_CHECKING([for $1[]_XTC])
  if test "${$1[]_XTC:+set}" = set; then
    AC_MSG_RESULT([explicitly set: $$1[]_XTC])
  else
    $1[]_XTC=`$PKG_CONFIG --variable=xtc_repo "$2"`
    AC_MSG_RESULT([$$1[]_XTC])
  fi

  AC_MSG_CHECKING([prefix of package $2])
  $1=`$PKG_CONFIG --variable=prefix "$2"`
  if test -z "$$1"; then
    AC_MSG_ERROR([package $2 does not specify its prefix in the pkg-config file.
          Report this error to the maintainer of this package.])
  else
    AC_MSG_RESULT([$$1])
  fi

m4_ifval([$3],
[test -f "$$1/$3" ||
  AC_MSG_ERROR([no such file: $$1/$3
        The configuration of package $2 claims that the package is
        installed at this location. Please check if the package is installed correctly.])
])dnl

  AC_SUBST([$1_CFLAGS])
  AC_SUBST([$1_LIBS])
  AC_SUBST([$1])
  AC_SUBST([$1_STRCFLAGS])
  AC_SUBST([$1_XTC])
])

# XT_SVN_REVISION
# ---------------
AC_DEFUN([XT_SVN_REVISION],
[
  AC_MSG_CHECKING([for the SVN revision of the source tree])

  if test -e "$srcdir/.svn"; then
    REVFIELD="1"
    SVN_REVISION=`svn info "$srcdir" | sed "/^Revision: /{;s///;p;};d"`
    AC_MSG_RESULT($SVN_REVISION)
  else
    if test -e "$srcdir/svn-revision"; then
      SVN_REVISION="`cat $srcdir/svn-revision`"
      AC_MSG_RESULT($SVN_REVISION)
    else
      SVN_REVISION="0"
      AC_MSG_RESULT([not available, defaulting to 0])
    fi
  fi

  AC_DEFINE_UNQUOTED([SVN_REVISION],"${SVN_REVISION}", [SVN revision])
  AC_SUBST([SVN_REVISION])
])

# XT_PRE_RELEASE
# --------------
# Extend version numbers with pre and svn revision to indicate an unstable build.
AC_DEFUN([XT_PRE_RELEASE],
[
  AC_REQUIRE([XT_SVN_REVISION])
  VERSION="${VERSION}pre${SVN_REVISION}"
  PACKAGE_VERSION="${PACKAGE_VERSION}pre${SVN_REVISION}"
])

# XT_TERM_DEFINE
# --------------
# CPP defines of some common variables as ATerms
AC_DEFUN([XT_TERM_DEFINE],
[
  AC_REQUIRE([XT_SVN_REVISION])

  AC_DEFINE_UNQUOTED([PACKAGE_NAME_TERM()],     [((ATerm) ATmakeString("${PACKAGE_NAME}"))], [ATerm package name])
  AC_DEFINE_UNQUOTED([PACKAGE_TARNAME_TERM()],  [((ATerm) ATmakeString("${PACKAGE_TARNAME}"))], [ATerm package tarname])
  AC_DEFINE_UNQUOTED([PACKAGE_VERSION_TERM()],  [((ATerm) ATmakeString("${PACKAGE_VERSION}"))], [ATerm package version])
  AC_DEFINE_UNQUOTED([VERSION_TERM()],          [((ATerm) ATmakeString("${VERSION}"))], [ATerm version])
  AC_DEFINE_UNQUOTED([PACKAGE_BUGREPORT_TERM()],[((ATerm) ATmakeString("${PACKAGE_BUGREPORT}"))], [ATerm bugreport email address])
  AC_DEFINE_UNQUOTED([SVN_REVISION_TERM()],     [((ATerm) ATmakeString("${SVN_REVISION}"))], [ATerm SVN revision])
])

############ TEST PACKAGES ########################################################

AC_DEFUN([XT_PKG_ATERM],
[
  XT_PROG_BAFFLE
])

AC_DEFUN([XT_PKG_PGEN],
[
  XT_PROG_SDF2TABLE
])

AC_DEFUN([XT_PKG_SGLR],
[
  XT_PROG_SGLR
])

AC_DEFUN([XT_PKG_PT_SUPPORT],
[
  XT_PROG_IMPLODEPT
])

AU_DEFUN([XT_PKG_ASF_LIBRARY], [XT_PKG_SDF_LIBRARY])

AC_DEFUN([XT_PKG_SDF_LIBRARY],
[
  AC_MSG_CHECKING([for sdf-library at $SDF/share/sdf-library])
  test -d "$SDF/share/sdf-library"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find sdf-library. Use --with-sdf.])
  fi
])

AC_DEFUN([XT_PKG_SDF],
[
  XT_PKG_PGEN
  XT_PKG_SGLR
  XT_PKG_PT_SUPPORT
  XT_PKG_SDF_LIBRARY
])

AC_DEFUN([XT_PKG_STRATEGOXT],
[
  XT_PROG_STRC
  XT_PROG_PACK_SDF
  XT_PROG_SDF2RTG
])

AC_DEFUN([XT_PKG_STRATEGOXT_UTILS],[])

############ TEST PROGRAMS ##########################################################

AC_DEFUN([XT_PROG_SDF2TABLE],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for sdf2table at $SDF/bin/sdf2table])
  test -x "$SDF/bin/sdf2table"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find sdf2table. Use --with-sdf or --with-pgen.])
  fi
])

AC_DEFUN([XT_PROG_IMPLODEPT],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for implodePT at $SDF/bin/implodePT$EXEEXT])
  test -x "$SDF/bin/implodePT$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find implodePT. Use --with-sdf or --with-pt-support.])
  fi
])

AC_DEFUN([XT_PROG_SGLR],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for sglr at $SDF/bin/sglr$EXEEXT])
  test -x "$SDF/bin/sglr$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find sglr. Use --with-sdf or --with-sglr.])
  fi
])

AC_DEFUN([XT_PROG_BAFFLE],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for baffle at $ATERM/bin/baffle$EXEEXT])
  test -f "$ATERM/bin/baffle$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find baffle. Use --with-aterm.])
  fi
])

AC_DEFUN([XT_PROG_XTC],
[
  AC_REQUIRE([XT_CHECK_XTC])
])

AC_DEFUN([XT_PROG_STRC],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for strc at $STRATEGOXT/bin/strc$EXEEXT])
  test -x "$STRATEGOXT/bin/strc$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find strc. Use --with-strategoxt to specify the location of StrategoXT])
  fi
])

AC_DEFUN([XT_PROG_PACK_SDF],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for pack-sdf at $STRATEGOXT/bin/pack-sdf$EXEEXT])
  test -x "$STRATEGOXT/bin/pack-sdf$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find pack-sdf. Use --with-strategoxt to specify the location of StrategoXT])
  fi
])

AC_DEFUN([XT_PROG_SDF2RTG],
[
  AC_REQUIRE([AC_PROG_CC])

  AC_MSG_CHECKING([for sdf2rtg at $STRATEGOXT/bin/sdf2rtg$EXEEXT])
  test -x "$STRATEGOXT/bin/sdf2rtg$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find sdf2rtg. Use --with-strategoxt to specify the location of StrategoXT])
  fi
])

############ TEST LIBRARIES ##########################################################

# XT_LIB_ATERM
# ------------
AC_DEFUN([XT_LIB_ATERM],
[
  AC_MSG_CHECKING([for libATerm at $ATERM/lib/libATerm.a])

  test -f $ATERM/lib/libATerm.a
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find libATerm.a. Is the ATerm library installed at this location?])
  fi
])
