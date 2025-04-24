#!/bin/bash
repo=$(pwd)

cd $repo || exit

git pull
git add -A
git commit -m "Update by script"
git push -u origin main
echo "Update Success!"
