#!/bin/bash

path=$1

gitpath=$2

rename=$3

mkdir -p $gitpath

curl $path -o $gitpath/$rename

git add -v .

git commit -m 'add file $rename'

git push

echo "https://sin90lzc.github.io/images/$gitpath/$rename"
