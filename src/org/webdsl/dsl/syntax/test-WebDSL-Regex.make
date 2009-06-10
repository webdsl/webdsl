all:
	pack-sdf -i test-WebDSL-Regex.sdf -o test-WebDSL-Regex.def
	sdf2table -i test-WebDSL-Regex.def -o test-WebDSL-Regex.tbl -m test-WebDSL-Regex
	sglri -A -p test-WebDSL-Regex.tbl -i test-WebDSL-Regex.txt -o __test-regex.txt
	cat __test-regex.txt | pp-aterm
	parse-pp-table -i WebDSL-pretty.pp -o __WebDSL-pretty.pp.af
	ast2text -p WebDSL-pretty.pp -i __test-regex.txt -o __test-regex-pretty.txt
	cat __test-regex-pretty.txt