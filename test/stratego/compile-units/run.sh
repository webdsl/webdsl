sed '2,8d' ../../../src/org/webdsl/dsl/transformation/import-modules.str > import-modules-copy.str
sed '2,5d' ../../../src/org/webdsl/dsl/utils/compile-units.str > compile-units-copy.str
sed '2,5d' ../../../src/org/webdsl/dsl/utils/remove-position-annos.str > remove-position-annos-copy.str
str -i test-compile-units.str -I ../../../src/org/webdsl/dsl/syntax/