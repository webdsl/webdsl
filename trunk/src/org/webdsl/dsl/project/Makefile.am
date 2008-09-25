bin_SCRIPTS = webdsl webdsl-plugins
EXTRA_DIST = \
  template/build.properties \
  template/build.xml \
  template/common.build.xml \
  template/embedded-ejb/readme.txt \
  $(wildcard template/embedded-ejb/properties/*.xml) \
  $(wildcard template/embedded-ejb/conf/*.xml) \
  $(wildcard template/lib/*.jar) \
  template/Makefile \
  $(wildcard template/resources/*.properties) \
  $(wildcard template/resources/*.drl) \
  $(wildcard template/resources/*.sql) \
  $(wildcard template/resources/*.xml) \
  $(wildcard template/resources/META-INF/*.xml) \
  $(wildcard template/resources/WEB-INF/*.xml) \
  $(wildcard template/view/*.html) \
  $(wildcard template/view/images/*.gif) \
  $(wildcard template/view/images/*.png) \
  $(wildcard template/view/javascript/*.js) \
  $(wildcard template/view/stylesheets/*.css) \
  $(wildcard new_project/*.app) \
  $(wildcard template-java-servlet/*.xml) \
  $(wildcard template-java-servlet/Makefile) \
  $(wildcard template-java-servlet/lib/*.jar) \
  $(wildcard template-java-servlet/src/*.properties) \
  $(wildcard template-java-servlet/src/utils/*.java) \
  $(wildcard template-java-servlet/javascript/*.js) \
  $(wildcard template-java-servlet/images/*.gif) \
  $(wildcard template-java-servlet/images/*.png) \
  $(wildcard template-java-servlet/stylesheets/*.css) \
  $(wildcard template-python/*.yaml) \
  $(wildcard template-python/*.py) \
  $(wildcard template-python/*.pyc) \
  $(wildcard template-python/*/*.*) \
  template-python/maak

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
