 #!/bin/sh
ppgen -i WebDSL.def -o __generated-webdsl-pp.pp
# parse-pp-table cannot parse this line
sed -e '/HqlStatement.1:parameterized-sort.1:"DeleteStatement"/d' -e '/HqlQuery.1:parameterized-sort.1:"QueryRule"/d' -e '/HqlQueryLimit.1:parameterized-sort.1:"QueryRule"/d' -e '/HqlQueryLimitOffset.1:parameterized-sort.1:"QueryRule"/d' __generated-webdsl-pp.pp > __generated-webdsl-pp-fixed.pp
parse-pp-table -i __generated-webdsl-pp-fixed.pp -o __generated-webdsl-pp.pp.af
parse-pp-table -i WebDSL-pretty.pp -o __WebDSL-pretty.pp.af
pptable-diff -i __generated-webdsl-pp.pp.af --old __WebDSL-pretty.pp.af 2> __ppdiff
cat __ppdiff
sed -n '/New entries/p' __ppdiff > __ppdiff_new_entries
#cat __ppdiff_new_entries
echo "" > __ppdiff_new_entries_for_insertion
for i in `cat __ppdiff_new_entries | grep -o \"[^\"]*\" | sed "s:\"::g"` ; do  
#  echo $i;
  sed -n '/'$i'/p' __generated-webdsl-pp-fixed.pp >> __ppdiff_new_entries_for_insertion
done;
cat __ppdiff_new_entries_for_insertion | uniq > __ppdiff_new_entries_for_insertion2
cat __ppdiff_new_entries_for_insertion2
