#!/bin/sh

echo "Testing 'webdsl new' application"
cd new_project
bash ../webdsl test hello > /dev/null 2> /dev/null