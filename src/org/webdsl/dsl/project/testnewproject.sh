#!/bin/sh
export
echo "Testing 'webdsl new' application"
cd new_project
bash /opt/webdsl-java/bin/webdsl test hello > /dev/null 2> /dev/null
