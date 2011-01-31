bin_SCRIPTS = webdsl webdsl-plugins webdsl.bat webdsl-eclipseplugin webdsl-eclipseplugin.bat

WEBDSL_TEMPLATES= \
  $(wildcard new_project/*.app) \
  $(wildcard new_project/stylesheets/*.css) \
  $(wildcard new_project/images/*.*) \
  template-java-servlet/webdsl-reindex \
  $(wildcard template-java-servlet/build.*) \
  $(wildcard template-java-servlet/lib/*.jar) \
  $(wildcard template-java-servlet/lib-test/*.jar) \
  $(wildcard template-java-servlet/src-template/*.properties) \
  $(wildcard template-java-servlet/src-template/utils/*.java) \
  $(wildcard template-java-servlet/html/*) \
  $(wildcard template-java-servlet/tomcat/*) \
  $(wildcard template-java-servlet/tomcat/.keystore) \
  $(wildcard template-java-servlet/javascript/*) \
  $(wildcard template-java-servlet/images/*.gif) \
  $(wildcard template-java-servlet/images/*.png) \
  $(wildcard template-java-servlet/stylesheets/*) \
  $(wildcard template-webdsl/*) 

EXTRA_DIST = \
  webdsl.bat \
  webdsl-eclipseplugin.bat \
  $(WEBDSL_TEMPLATES) \
  testnewproject.sh
  
TESTS = testnewproject.sh

nobase_dist_pkgdata_DATA = \
  $(filter-out template-java-servlet/lib/webdsl-support.jar,$(WEBDSL_TEMPLATES)) \
  template-java-servlet/lib/webdsl-support.jar \
  webdsl-build.xml \
  webdsl-build-command.xml \
  webdsl-build-deploy.xml \
  webdsl-build-new.xml \
  webdsl-build-help.xml \
  webdsl-build-check.xml \
  webdsl-build-clean.xml \
  webdsl-build-eclipse.xml \
  webdsl-build-index.xml

# probably enough depth
JAVA_RUNTIME_DEPENDENCIES = \
  $(wildcard $(top_srcdir)/java-runtime/src/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*/*/*/*.java)
  
template-java-servlet/lib/webdsl-support.jar : $(JAVA_RUNTIME_DEPENDENCIES)
	ant -f $(top_srcdir)/java-runtime/build.xml deploy

install-data-local:
	mkdir -p $(pkgdatadir)/template/app
	mkdir -p $(pkgdatadir)/template/dist
	mkdir -p $(pkgdatadir)/template/exploded-archives
	mkdir -p $(pkgdatadir)/template/server/default/log
	mkdir -p $(pkgdatadir)/template/src
	mkdir -p $(pkgdatadir)/template/test
	mkdir -p $(pkgdatadir)/new_project
	mkdir -p $(pkgdatadir)/template-java-servlet
	mkdir -p $(pkgdatadir)/template-java-servlet/lib
	mkdir -p $(pkgdatadir)/template-java-servlet/src-template
	mkdir -p $(pkgdatadir)/template-java-servlet/src-template/utils
	mkdir -p $(pkgdatadir)/template-webdsl

bootclean:
