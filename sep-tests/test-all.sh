
curdir=`pwd`
find . -name "main.app" | grep -v "test-run/" | while read i; do
	cd $curdir
	test=`dirname $i`
	echo "TESTING: $test"
	./test.sh $test
	echo ""
	echo ""
done

