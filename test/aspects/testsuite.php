<?php

function compile($file) {
  
  echo "Testing: $file\n";
  $filename = $file . ".nwl";
  touch($filename); // force compilation
  sleep(1); // Too fast otherwise.. timestamps of cache == timestamp of file
  $cmd = "/home/nathan/nwl/trans/nwlj --verbose 2 -i $filename 2>&1 ";
	exec($cmd, $output, $ret);
	if ($ret !== 0) {
	 echo("Error executing: $cmd\n");
	 echo(implode("\n", $output));
	 echo("\n");
	 die();
	}
	$data = array();
	$data['written'] = array();
	$data['files'] = array();
	foreach($output as $line) {
		if (preg_match("_Write file (.*):[ ]*\.generated/(.*)\.java_", $line, $matches)) {
			$data['written'][$matches[2]] = array('type' => $matches[1]);
			array_push($data['files'], $matches[2]);
		}
	}
	//echo "---\n\n";
	//echo implode("\n", $output);
	return $data;

}

function checkFiles($title, $data, $files) {
	foreach($data['files'] as $file) {
		if (!in_array($file, $files)) {
			echo "$title: File should not be written to: $file\n";
		}
	}
	foreach($files as $file) {
		if (!in_array($file, $data['files'])) {
			echo "$title: File should be written to: $file\n";
		}
	}
}

// Fresh start
exec("./clean");
compile("main");

// Test 1: if entity Entry changed, its view page must also be recompiled
$data = compile("data");
checkFiles("Test:data", $data, array("Entry", "view_Entry", "login"));

// Test 2: if access control has changed, recompile all templates + pages
$data = compile("ac");
checkFiles("Test:acl", $data, array("main", "main134", "root", "login", "pred_ac_AccessControlRule_3_8", "pred_ac_AccessControlRule_3_9", "pred_ac_AccessControlRule_3_10", "pred_ac_AccessControlRule_3_14"));

// Test 3: if page access control has changed, recompile all pages
$data = compile("pageac");
checkFiles("Test:pageacl", $data, array("root", "login", "pred_pageac_AccessControlRule_3_8"));

// Test 4: if logging has changed, recompile entity and its generated view page
$data = compile("logging");
checkFiles("Test:logging", $data, array("Entry", "login", "view_Entry"));

?>
