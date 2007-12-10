#     							-*- Autoconf -*-
# serial 2
#
# Author: Martin Bravenboer <martin@cs.uu.nl>
#

# XT_USE_JAVA_FRONT
# --------------
AC_DEFUN([XT_USE_JAVA_FRONT], [
  XT_CHECK_PACKAGE([JAVA_FRONT],[java-front])

  AC_MSG_CHECKING([for parse-java at $JAVA_FRONT/bin/parse-java$EXEEXT])
  test -x "$JAVA_FRONT/bin/parse-java$EXEEXT"
  if test $? -eq 0; then
    AC_MSG_RESULT([yes])
  else
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([cannot find parse-java. Is java-front installed correctly?])
  fi
])
