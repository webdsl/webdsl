bin_SCRIPTS = webdsl webdsl-plugins
EXTRA_DIST = \
  $(wildcard new_project/*.app) \
  $(wildcard new_project/stylesheets/*.css) \
  $(wildcard new_project/images/*.*) \
  $(wildcard template-java-servlet/build.xml) \
  $(wildcard template-java-servlet/build.properties) \
  $(wildcard template-java-servlet/Makefile) \
  $(wildcard template-java-servlet/lib/*.jar) \
  $(wildcard template-java-servlet/lib-test/*.jar) \
  $(wildcard template-java-servlet/src/*.properties) \
  $(wildcard template-java-servlet/src/utils/*.java) \
  $(wildcard template-java-servlet/html/*) \
  $(wildcard template-java-servlet/tomcat/*) \
  $(wildcard template-java-servlet/javascript/*) \
  $(wildcard template-java-servlet/images/*.gif) \
  $(wildcard template-java-servlet/images/*.png) \
  $(wildcard template-java-servlet/stylesheets/*) \
  $(wildcard template-python/*.yaml) \
  $(wildcard template-python/*.py) \
  $(wildcard template-python/*.pyc) \
  $(wildcard template-python/*/*.*) \
  template-python/maak \
  testnewproject.sh
  
TESTS = testnewproject.sh

nobase_dist_pkgdata_DATA = $(EXTRA_DIST)

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
