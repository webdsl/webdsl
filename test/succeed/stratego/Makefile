default : read-imports.ctree .seamapp

.seamapp : *
	webdsl clean build deploy

%.ctree : %.str
	strc -F --library -i $< -o $@ -la stratego-lib

