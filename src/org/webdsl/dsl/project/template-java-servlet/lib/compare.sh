# discover difference with maven jar when md5 hash does not match
# test.sh downloads new maven jar dependencies to tmp/ subfolder
# example usage ./compare.sh jsoup-1.7.2.jar

unzip $1 -d jarcontent/
unzip tmp/$1 -d tmp/jarcontent
diff -r jarcontent tmp/jarcontent
rm -rf jarcontent
rm -rf tmp/jarcontent
