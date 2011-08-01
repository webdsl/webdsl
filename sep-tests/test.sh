#!/bin/bash

seppath=~/webdsl-java
comppath=~/webdsl-svn-java

options="--enable-caching 1 --verbose 3 --servlet --indexdir /var/indexes"

basedir=`pwd`

# *absolute* path to this script
framework_dir=`dirname $(readlink -f $0)`

export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
JALOPY=~/jalopy/jalopy.sh 

function usage {
	echo "Usage: $0 testcase [-n]"
}

# Arguments
prog=$1
shift
if [ "$prog" == "" ]; then
	usage
	exit
fi

recompile_base=1
while getopts "nh" OPTION
do
	case $OPTION in
		h)
			usage
             		exit 1
			;;
		n)
			recompile_base=0
			;;
    	esac
done

progdir=$(readlink -f $prog)

function compile {
	echo "Compiling $curr version..."
	cd .servletapp
	# use -Xss8m for now
	time java -Xss8m -jar $1/src/webdsl.jar -i ../main.app $options &> ../compile.log
	STATUS=$?
	if [ $STATUS != 0 ]; then
		echo "ERROR: Compilation $curr failed."
		cat ../compile.log
		exit 1
	fi

	# remove non-deterministic variable numbering
	find -name "*.java" | while read f; do
		# replace id123 with id0
		sed -r "s/([a-zA-Z]+)[0-9]+/\10/g" -i $f
	done

	# format source (sort methods)
	$JALOPY -r src-generated &> ../jalopy.log
	[ $? -ne 0 ] && echo "Jalopy failed." && cat ../jalopy.log && exit 1
	
	# touch cache to make it newer than the modified java files
	find ../.webdsl-fragment-cache | \
		xargs touch
	# Problem: objCr functions are emitted in different orderings
	find -type f | \
		xargs md5sum | \
		sed -r 's/(.*)([ ])+(.*)/\3\2\1/' | \
		egrep -v "_objCr[0-9]+_" | \
		sort \
		> ../checksum.txt
	cd ..
}

# clean
function clean {
	rm -rf .webdsl-parsecache
	rm -rf .servletapp
	mkdir -p .servletapp/src-webdsl-template
	cp -r $template_src_dir/* $template_dst_dir
	rm -rf .webdsl-fragment-cache
}

testdir=$basedir/test-run
template_src_dir=$seppath/src/org/webdsl/dsl/project/template-webdsl
template_dst_dir=.servletapp/src-webdsl-template

function create {
	n=$1
	mkdir -p $testdir/$curr
	cd $testdir/$curr
	for i in $progdir/*.app; do
		php $framework_dir/create.php $i `basename $i` $n
	done
}

function check_diff {
	if ! diff -q $1/checksum.txt $2/checksum.txt &> /dev/null; then
		echo "Showing differences of compile $1 and $2"
		fail=1
	fi
	# Due to the grep, we don't see files that remain on the right side but are deleted on the left side.
	diff -N $1/checksum.txt $2/checksum.txt --suppress-common-lines | \
   	  grep "^< " | \
	  cut -d " " -f 2 | \
	  while read i; do
		# Show differences in file i
		echo "############# File $i is different"
		diff $1/.servletapp/$i $2/.servletapp/$i
		echo && echo
	done
}


function prepare {
	# prepare current output directory with the java files from a previous compile
	cp -r $testdir/$1/.webdsl-fragment-cache .
	cp -r $testdir/$1/.servletapp .
}

compile=1

if (( $compile )); then

	# clean start
	if (( $recompile_base )); then
		rm -rf $testdir
		mkdir -p $testdir			
	else
		rm -rf $testdir/sep*
	fi
	
	cd $testdir

	# create app 1
	if (( $recompile_base )); then
		curr="base-1"
		create 1
		clean
		compile $comppath
	
		# create app 2
		curr="base-2"
		create 2
		prepare base-1
	
		clean
		compile $comppath
	fi

	curr="sep-1a"
	create 1

	clean
	compile $seppath

	# save all files
	cd $testdir
	cp -r -p sep-1a sep-1b
	cd sep-1b

	curr="sep-1b"
	compile $seppath
	
	# copy files from sep-1a to sep-2
	cd $testdir
	cp -r -p sep-1a sep-2
	cd sep-2

	curr="sep-2"
	create 2		#only touches files that are changed
	compile $seppath

	# copy files from sep-2 to sep-3
	cd $testdir
	cp -r -p sep-2 sep-3
	cd sep-3

	curr="sep-3"
	create 1
	compile $seppath
fi

cd $testdir
check_diff base-1 sep-1a
check_diff sep-1a sep-1b
check_diff base-2 sep-2
check_diff base-1 sep-3

if [ $fail ]; then
	echo "ERROR: differences found."
	exit 1
else 
	echo "Success."
fi



