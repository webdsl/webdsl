# tfm.m4: extra m4 macros for Transformers.
# Copyright (C) 2006  EPITA Research and Development Laboratory.
#
# Transformers is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
#

# _TFM_ADD_ARG_WITH(pkg-name)
# ---------------------------
# Internal. Adds a --with-<pkg-name>-xtc=FILE_TO_XTC_REPOS option to configure.
AC_DEFUN([_TFM_ADD_ARG_WITH],
[
  m4_pushdef([m4_var], AS_TR_CPP([$1_XTC]))dnl
  dnl FIXME: Autoconf doesn't seem to handle properly multiple definitions
  dnl of the same --with-arg. Producing side-effects (such as echo'ing
  dnl something) in the two last arguments of AC ARG WITH will lead to the
  dnl echo being displayed multiple times.
  AC_ARG_WITH([$1-xtc],
              [AS_HELP_STRING([--with-$1-xtc=path],
                              [path to the XTC repository of $1])],
              [m4_var="$withval"], [m4_var=''])
  if test "x$m4_var" = x; then
    if $PKG_CONFIG --exists $1; then
      m4_var=`$PKG_CONFIG --variable=xtc $1`
    elif $PKG_CONFIG --exists transformers-$1; then
      m4_var=`$PKG_CONFIG --variable=xtc transformers-$1`
    fi
  fi

  # FIXME: this if simply prevents multiple checks if ac_cv_path_<pkg-name>
  # was already filled.
  if test "x$ac_cv_path_[]m4_var" = x; then
    AC_CACHE_CHECK([for $1's XTC repository], [ac_cv_path_[]m4_var],
    [if test "x$m4_var" = x; then
       ac_cv_path_[]m4_var=no
     else
       ac_cv_path_[]m4_var="$m4_var"
     fi
    ])
    if test "x$m4_var" != x && test ! -r "$m4_var"; then
      AC_MSG_ERROR([Cannot read the XTC repository of $1])
    fi
  fi
  AC_SUBST(m4_var)dnl
  m4_popdef([m4_var])dnl
])

# TFM_CHECK_PROG(pkg-name, tools-list)
# ------------------------------------
# Indicate that tools-list are required for the build. tools-list must be a
# string containing comma-separated names of executable binaries required for
# the build process.
# For each tool-name in tools-list, a make variable $(TOOL_NAME) will be
# filled with the full path to tool-name.
#
# An option --with-<pkg-name>-xtc will be added. If this option is used, the
# tools will first be looked up in the XTC repository indicated. Otherwise
# they will be searched in the PATH.
AC_DEFUN([TFM_CHECK_PROG],
[
  _TFM_ADD_ARG_WITH([$1])

  m4_foreach(m4_i, [$2],
  [
    m4_pushdef([m4_var], AS_TR_CPP(m4_i))dnl

    if test "x$AS_TR_CPP([$1])_XTC" != x; then
      AC_CACHE_CHECK([for m4_i in $1], [ac_cv_path_[]m4_var],
      [ac_cv_path_[]m4_var=''
       if test -n "$m4_var"; then
         ac_cv_path_[]m4_var="$m4_var" # Let the user override the test.
       else
         m4_var="`$XTC_PROG -r $AS_TR_CPP([$1])_XTC query -t m4_i -L | sed '1!d'`"
         # when xtc doesn't find an answer to the query, it will still return 0
         # and simply write "tool-name : no registration" on STDOUT! :(
         # In case of a problem with the XTC repository (such as an empty file)
         # xtc will typically display its argv as an ATerm list.
         if test "x$m4_var" = "x[]m4_i : no registration" || \
            test x`echo $r | sed '1s/^\@<:@.*,"-r",.*\@:>@$/fail/'` = xfail; then
           m4_var=''
           ac_cv_path_[]m4_var=''
         else
           ac_cv_path_[]m4_var="$m4_var"
           echo "$as_me:$LINENO: found $m4_var" >&AS_MESSAGE_LOG_FD
         fi
       fi
      ])
      # Update m4_var with the XTC_REPOSITORY or populate it in case of a cache hit
      m4_var="XTC_REPOSITORY='$AS_TR_CPP([$1])_XTC' $ac_cv_path_[]m4_var"
    fi

    if test "x$m4_var" = x; then
      AC_PATH_PROGS(m4_var, m4_i)
      # FIXME: AC_PATH_PROGS returns the full path to the prog.
      #        The following finds the directory where the prog is and might
      #        not be the best thing to do. It might not be portable (?)
      #        I mean, is this the best way of doing it?
      test "x$m4_var" != x && m4_var="`dirname $m4_var`"
    fi

    if test "x$m4_var" = x; then
      if test "x$AS_TR_CPP([$1])_XTC" = x; then
        AC_MSG_ERROR([Cannot find m4_i in \$PATH.])
      else
        AC_MSG_ERROR([Cannot find m4_i in the XTC repository of $1 ($AS_TR_CPP([$1])_XTC) or in the \$PATH.])
      fi
    fi

    AC_SUBST(m4_var)dnl
    m4_popdef([m4_var])dnl
  ])
])

# TFM_CHECK_INCLUDES(pkg-name, tool-name, files-list)
# ---------------------------------------------------
# Indicate that tool-name's files in files-list are required for the build.
# A make variable $(TOOL_NAME_INCLUDES) will be filled containing the
# proper -I's needed to include the files in files-list.
#
# files-list is a comma-separated list of file names.
#
# An option --with-<pkg-name>-xtc will be added. The files will be looked up
# in that XTC repository if the option is used.
AC_DEFUN([TFM_CHECK_INCLUDES],
[
  _TFM_ADD_ARG_WITH([$1])

  if test "x$AS_TR_CPP([$1])_XTC" = x; then
    AC_MSG_ERROR([Cannot find the includes of $2 without $1's XTC repository. Use --with-$1-xtc.])
  fi

  m4_pushdef([m4_var], AS_TR_CPP([$2_INCLUDES]))dnl
  m4_foreach(m4_i, [$3],
  [
    AC_CACHE_CHECK([for m4_i in $2 (in $1)], [ac_cv_header_[]AS_TR_SH(m4_i)],
    [ac_cv_header_[]AS_TR_SH(m4_i)="`$XTC_PROG -r $AS_TR_CPP([$1])_XTC query -t m4_i -L | sed '1!d'`"
     # when xtc doesn't find an answer to the query, it will still return 0
     # and simply write "tool-name : no registration" on STDOUT! :(
     # In case of a problem with the XTC repository (such as an empty file)
     # xtc will typically display its argv as an ATerm list.
     if test "x$ac_cv_header_[]AS_TR_SH(m4_i)" = "x[]m4_i : no registration" || \
        test x`echo $r | sed '1s/^\@<:@.*,"-r",.*\@:>@$/fail/'` = xfail; then
       AC_MSG_ERROR([Cannot find m4_i in $1's XTC repository.])
     fi
    ])
    echo "$as_me:$LINENO: found $ac_cv_header_[]AS_TR_SH(m4_i)" >&AS_MESSAGE_LOG_FD
    tfm_tmp=`dirname "$ac_cv_header_[]AS_TR_SH(m4_i)"`
    m4_var="$m4_var -I '$tfm_tmp'"
  ])
  AC_SUBST(m4_var)dnl
  m4_popdef([m4_var])dnl
])

# TFM_CHECK_LIBS(pkg-name, tool-name, files-list)
# -----------------------------------------------
# Indicate that tool-name's libraries specified in files-list are required
# for the build.
# A make variable $(TOOL_NAME_LIBS) will be filled containing the full paths
# to the libraries specified in files-list.
#
# files-list is a comma-separated list of library names. If your library is
# named libfoo.la, then simply use `foo' or the full name libfoo.la.
#
# An option --with-<pkg-name>-xtc will be added. The files will be looked up
# in that XTC repository if the option is used.
AC_DEFUN([TFM_CHECK_LIBS],
[
  _TFM_ADD_ARG_WITH([$1])

  if test "x$AS_TR_CPP([$1])_XTC" = x; then
    AC_MSG_ERROR([Cannot find the libraries of $2 without $1's XTC repository. Use --with-$1-xtc.])
  fi

  m4_pushdef([m4_var], AS_TR_CPP([$2_LIBS]))dnl
  m4_foreach(m4_i, [$3],
  [
    AC_CACHE_CHECK([for the library m4_i in $2 (in $1)], [ac_cv_lib_[]AS_TR_SH(m4_i)],
    [for tfm_lib in \
      "lib[]m4_i[].la" "m4_i[].la" \
      "lib[]m4_i[].so" "m4_i[].so" \
      "lib[]m4_i[].a" "m4_i[].a" \
      "lib[]m4_i[].dylib" "m4_i[].dylib" \
      "m4_i"; do
       ac_cv_lib_[]AS_TR_SH(m4_i)="`$XTC_PROG -r $AS_TR_CPP([$1])_XTC query -t $tfm_lib -L | sed '1!d'`"
       # when xtc doesn't find an answer to the query, it will still return 0
       # and simply write "tool-name : no registration" on STDOUT! :(
       # In case of a problem with the XTC repository (such as an empty file)
       # xtc will typically display its argv as an ATerm list.
       if test "x$ac_cv_lib_[]AS_TR_SH(m4_i)" != "x[]$tfm_lib : no registration" || \
          test x`echo $r | sed '1s/^\@<:@.*,"-r",.*\@:>@$/fail/'` = xfail; then
         break
       else
         ac_cv_lib_[]AS_TR_SH(m4_i)=''
       fi
     done
    ])

    if test "x$ac_cv_lib_[]AS_TR_SH(m4_i)" = x; then
     AC_MSG_ERROR([Cannot find the library m4_i in $1's XTC repository.])
    fi

    echo "$as_me:$LINENO: found $ac_cv_lib_[]AS_TR_SH(m4_i)" >&AS_MESSAGE_LOG_FD
    m4_var="$m4_var '$ac_cv_lib_[]AS_TR_SH(m4_i)'"
  ])
  AC_SUBST(m4_var)dnl
  m4_popdef([m4_var])dnl
])

# TFM_PROG_CPP
# ------------
# We need to register a CPP in our XTC repository. Since our custom
# implementation of cpp/uncpp hasn't made it into Transformers, we
# temporarily add an option --with-cpp=path-to-cpp (if not specified the
# we'll look for cpp in the PATH).
AC_DEFUN([TFM_PROG_CPP],
[AC_REQUIRE([AC_CANONICAL_HOST])
AC_ARG_WITH([cpp],
            [AS_HELP_STRING([--with-cpp=path],
                            [custom path to CPP used by c-tools parsers. @<:@Find in \$PATH@:>@])],
            [CPP="$withval"])

if test x"$CPP" = x; then
  AC_MSG_ERROR([Cannot find cpp. Use --with-cpp.])
else
  case $host_os in
    darwin*)
      # On Darwin /usr/bin/cpp is traditionally a script (probably installed
      # by Apple XCODE) that just sux and doesn't work with common options
      # used by Transformers (such as -x language, -o output file etc).
      # Basically the script just calls gcc -E. By putting CPP_XTC=Darwin and
      # by using an Automake Conditional (see below) we'll conditionally
      # install a replacement script for cpp on MacOSX.
      if test x"$CPP" = xcpp && file `which cpp` | grep -q script; then
        CPP='gcc -E' # Activate the workaround for MacOSX
      fi
    ;;
  esac
fi
echo "$as_me:$LINENO: found cpp at $CPP" >&AS_MESSAGE_LOG_FD
])
