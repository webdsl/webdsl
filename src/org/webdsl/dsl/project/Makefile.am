bin_SCRIPTS = webdsl webdsl-plugins webdsl.bat webdsl-eclipseplugin webdsl-eclipseplugin.bat

WEBDSL_TEMPLATES= \
  $(wildcard new_project/*.app) \
  $(wildcard new_project/stylesheets/*.css) \
  $(wildcard new_project/search/*.app) \
  $(wildcard new_project/search/analyzerfiles/*.txt) \
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

COMPILE_JARS = template-java-servlet/lib/webdsl-support.jar template-java-servlet/lib/webdsl-built-ins.jar 

# Note:
#   $(filter-out template-java-servlet/lib/webdsl-support.jar,$(WEBDSL_TEMPLATES)) \ 
#	  template-java-servlet/lib/webdsl-support.jar \
# is not the same as
#   $(WEBDSL_TEMPLATES)
# the latter does not trigger the template-java-servlet/lib/webdsl-support.jar target if it was not build before
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
  webdsl-build-eclipse-plugin-entry.xml \
  webdsl-build-index.xml

# probably enough depth
JAVA_RUNTIME_DEPS = \
  $(wildcard $(top_srcdir)/java-runtime/src/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*/*/*.java) \
  $(wildcard $(top_srcdir)/java-runtime/src/*/*/*/*/*/*/*.java)
  
template-java-servlet/lib/webdsl-support.jar : $(JAVA_RUNTIME_DEPS)
	ant -f $(top_srcdir)/java-runtime/build.xml deploy

# precompile built-in.app, see precompile-built-ins
install-data-hook:
	echo 'precompiling built-in.app'
	$(shell cd $(top_srcdir)/precompile-built-ins/; $(bindir)/webdsl cleanall check &> compile_output.txt)
	cat $(top_srcdir)/precompile-built-ins/compile_output.txt
	echo 'finished precompiling built-in.app'
	ant -f $(top_srcdir)/precompile-built-ins/build.xml deploy
	cp template-java-servlet/lib/webdsl-built-ins.jar $(pkgdatadir)/template-java-servlet/lib

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
