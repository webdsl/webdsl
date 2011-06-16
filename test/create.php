<?php

if ($argc != 4) {
	echo "Usage: php {$argv[0]} baseFile outFile version\n";
	die();
}

$outFile = $argv[2];
if (!file_exists($argv[1])) die("File $baseFile does not exist.");
$baseFile = file_get_contents($argv[1]);

function produce($n) {
	global $baseFile, $outFile, $current;
	$current = $n;
	
	$res = $baseFile;
	
	$res = preg_replace_callback("/-- START ([A-Z]+) --(.*)?-- END \\1 --/s", "replace", $res);
	$res = preg_replace_callback("/-- START ([A-Z0-9]+) ([A-Z0-9]+) --(.*)?-- END \\1 \\2 --/s", "replace", $res);
	$res = preg_replace("/#1/", $n, $res);
	
	$old = @file_get_contents($outFile);
	if ($old == $res) {
		echo "Skipping same file: $outFile\n";
	} else {
		file_put_contents($outFile, $res);
	}
}

function replacen($txt, $n) {
	return preg_replace("/#1/", $n, $txt);
}

function replace($matches) {
	
	global $current;
	switch($matches[1]) {
		case "DOUBLE":
			return $current==1 ? replacen($matches[2], 1) . "\n// --------\n" . replacen($matches[2],2) :
				replacen($matches[2], 2);
		case "ONLY":
			return ("".$current) == $matches[2] ? $matches[3] : '';
		default:
			die("Invalid: ". $matches[1]);
	} 
}

produce($argv[3]);

?>
