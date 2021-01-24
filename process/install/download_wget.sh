#!/bin/bash
mkdir $(dirname "$0")/../../data/popular-4k && cd popular-4k
wget -c -q --show-progress -A gz,sql -nd -r -np -nH https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/
sed -i 's/zcat/gzip -cd/g' load.sql