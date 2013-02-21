benchmark.sh performs benchmarking on a set of test cases.
A test case has a:
* war-file, which is a compiled WebDSL application
* sql.gz-file, which is a dump of the database
* A page, which also includes the arguments

Steps performed for each test case:
1 Deploy war-file to Tomcat
2 Restore sql.gz-file to the MySQL database
3 Send warmup requests with extra logging enabled
4 Benchmark the specified page by sending requests for it
5 Terminate Tomcat
6 Cleanup (remove war-file and temporary files)
7 Write results to the output

Test cases and other options are defined in a configuration file. An example of such a configuration file 
is provided by example.cfg, which also explains the options. The configuration script to be used should be
the first argument to benchmark.sh. So for example.cfg:

./benchmark.sh example.cfg

Tools which should be installed:
* ab (Apache HTTP server benchmarking tool)
* mysql (The MySQL command-line tool)
* gzip
* wget (The non-interactive network downloader)
* bc (An arbitrary precision calculator language)
* awk (An interpreter for the AWK Programming Language)
* Oracle JDK 7
* jmap (Memory Map, included with the JDK)
* Apache Tomcat

The script has been tested with Oracle JDK 7 using the parallel garbage collector (-XX:+UseParallelGC).
With other versions of the JDK or with other garbage collectors the garbage collection log may look 
different and the regular expressions inside this script may need to be changed.

The script can be terminated and continued later, by executing it again using the same configuration file.
Inside the output directory the most interesting files are <war-filename>_<sql.gz-filename>.log. These
contain a tab-separated line for each page tested on that war/sql combination. For a directly readable files
there are also *.txt files with the same name. The columns have the following meaning:
* Name          = The name of the page
* Min           = The shortest response time measured (ms)
* Mean          = The mean/average response time measured (ms)
* [+/-sd]       = The standard deviation of the response time (ms)
* Median        = The median of the response time (ms)
* Max           = The longest response time measured (ms)
* 80%           = 80% of the requests completed within this time (ms)
* 90%           = 90% of the requests completed within this time (ms)
* Queries       = The number of sql queries executed during warmup requests (can be a "min-max" value if it was not constant)
* Entities      = The number of fetched entities during warmup requests (can be a "min-max" value if it was not constant)
* Duplicates    = The number of duplicate entities inside returned record-sets during warmup requests (can be a "min-max" value if it was not constant)
* Collections   = The number of fetched collections during warmup requests (can be a "min-max" value if it was not constant)
* YoungGC       = Number of young generation garbage collections performed after the warmup requests
* FullGC        = Number of full garbage collections performed after the warmup requests
* GCUser        = Time spend in user mode during garbage collection after the warmup requests (ms)
* GCSys         = Time spend in system mode during garbage collection after the warmup requests (ms)
* GCReal        = Real time spend garbage collecting after the warmup requests (ms)
* Young         = Young generation heap memory used after warmup requests (MB)
* Old           = Old generation heap memory used after warmup requests (MB)
* Heap          = Total heap memory used after warmup requests (MB)
* Perm          = Total PermGen memory used after warmup requests (MB)
* HeapPerReq    = Total heap memory used divided by the number of iterations, to get the average heap memory used per request (MB)
* YoungT        = Same a Young, but including memory released during tomcat termination (MB)
* OldT          = Same a Old, but including memory released during tomcat termination (MB)
* HeapT         = Same a Heap, but including memory released during tomcat termination (MB)
* PermT         = Same a Perm, but including memory released during tomcat termination (MB)
* AvgSql        = If Queries is a "min-max" value, then this is the average value, otherwise it is the same as Queries
* AvgEnt        = If Entities is a "min-max" value, then this is the average value, otherwise it is the same as Entities
* AvgDup        = If Duplicates is a "min-max" value, then this is the average value, otherwise it is the same a Duplicates
* AvgCol        = If Collections is a "min-max" value, then this is the average value, otherwise it is the same a Collections
* CntMaxEnt     = If Entities is a "min-max" value, then this is the number of warmup requests that fetched the maximum number of entities, otherwise this is the same as WARMUP
* MaxEntPer     = The percentage of warmup requests that fetched the maximum number of entities (will be 100 if Entities is not a "min-max" value)

