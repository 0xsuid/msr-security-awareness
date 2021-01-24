@echo off
mkdir %~dp0..\..\data\popular-4k & cd popular-4k
for /F %%I in ('curl -s https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/ ^| grep -Po "(?<=<a href="")[^^"".]*(\.csv\.gz|\.sql)"') do (
    echo Downloading %%I & curl --progress-bar -O https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/%%I
)
sed -i 's/zcat/gzip -cd/g' load.sql