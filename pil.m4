#     							-*- Autoconf -*-
# serial 2
#
# Author: Zef Hemel <zef@zefhemel.com>
#

# XT_USE_PIL
# --------------
AC_DEFUN([XT_USE_PIL], [
  XT_CHECK_PACKAGE([PIL],[pil])

  AC_MSG_CHECKING([for pilc at $PIL/bin/pilc$EXEEXT])
  test -x "$PIL/bin/pilc$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find parse-java. Is java-front installed correctly?])
  fi

  PIL_LIB=`$PKG_CONFIG --variable=libdir pil`
  AC_SUBST([PIL_LIB])
  
])
