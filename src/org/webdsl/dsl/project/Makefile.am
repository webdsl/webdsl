bin_SCRIPTS = webdsl webdsl-plugins webdsl.bat

WEBDSL_TEMPLATES= \
  $(wildcard new_project/*.app) \
  $(wildcard new_project/stylesheets/*.css) \
  $(wildcard new_project/images/*.*) \
  $(wildcard template-java-servlet/build.xml) \
  $(wildcard template-java-servlet/build.properties) \
  $(wildcard template-java-servlet/lib/*.jar) \
  $(wildcard template-java-servlet/lib-test/*.jar) \
  $(wildcard template-java-servlet/src/*.properties) \
  $(wildcard template-java-servlet/src/utils/*.java) \
  $(wildcard template-java-servlet/html/*) \
  $(wildcard template-java-servlet/tomcat/*) \
  $(wildcard template-java-servlet/javascript/*) \
  $(wildcard template-java-servlet/images/*.gif) \
  $(wildcard template-java-servlet/images/*.png) \
  $(wildcard template-java-servlet/stylesheets/*) 

EXTRA_DIST = \
  $(WEBDSL_TEMPLATES) \
  testnewproject.sh
  
TESTS = testnewproject.sh

nobase_dist_pkgdata_DATA = $(WEBDSL_TEMPLATES) \
                           webdsl-build.xml \
                           webdsl-build-command.xml \
                           webdsl-build-deploy.xml \
                           webdsl-build-new.xml \
                           webdsl-build-help.xml \
                           webdsl-build-check.xml \
                           webdsl-build-clean.xml \
                           webdsl-build-index.xml

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
	mkdir -p $(pkgdatadir)/template-java-servlet/src
	mkdir -p $(pkgdatadir)/template-java-servlet/src/utils
	mkdir -p $(pkgdatadir)/template-python

bootclean:
