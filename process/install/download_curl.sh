#!/bin/bash
mkdir $(dirname "$0")/../../data/popular-4k && cd popular-4k
for file in $(curl -s https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/ |
                 grep -Po '(?<=<a href=")[^".]*(\.csv\.gz|\.sql)'); do
    curl --progress-bar -O https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/$file
done
sed -i 's/zcat/gzip -cd/g' load.sql