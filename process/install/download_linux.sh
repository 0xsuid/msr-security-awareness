#!/bin/bash

function menu {
echo "select the operation ************"
echo "  1. Download Dataset & CVE Manager with Wget"
echo "  2. Download Dataset & CVE Manager with Curl"
echo "  3. Load Dataset into Database"
echo "  4. Create Tables (cve_revs,cve_revs_js,cve_revs_py)"
echo "  5. Download NVD & Get CVE related issues"
echo "  6. Exit" 

read n
case $n in
    1)  echo "1. Download Dataset & CVE Manager with Wget"
        download_wget
        ;;
    2)  echo "2. Download Dataset & CVE Manager with Curl"
        download_curl
        ;;
    3)  echo "3. Load Dataset into Database"
        load_dataset
        ;;
    4)  echo "4. Create Tables (cve_revs,cve_revs_js,cve_revs_py)"
        create_tables
        ;;
    5)  echo "5. Download NVD & Get CVE related issues"
        create_tables
        ;;
    6)  echo "Bye"
        exit
        ;;
    *) echo "invalid option";;
esac
}


function download_wget {
    echo "Downloading Dataset"
    mkdir -p $(dirname "$0")/../../data/popular-4k && cd $(dirname "$0")/../../data/popular-4k
    wget -c -q --show-progress -A gz,sql -nd -r -np -nH https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/
    sed -i 's/zcat/gzip -cd/g' load.sql
    cd $(dirname "$0")/../code/
    wget -P ../code/ https://raw.githubusercontent.com/0xsuid/cve_manager/master/cve_manager.py
    printf "Download Complete\n"
    menu
}

function download_curl {
    echo "Downloading Dataset"
    mkdir -p $(dirname "$0")/../../data/popular-4k && cd $(dirname "$0")/../../data/popular-4k
    for file in $(curl --progress-bar https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/ |
                    grep -Po '(?<=<a href=")[^".]*(\.csv\.gz|\.sql)'); 
    do
        echo "$file"
        curl --progress-bar -O https://annex.softwareheritage.org/public/dataset/graph/latest/popular-4k/sql/$file
    done
    sed -i 's/zcat/gzip -cd/g' load.sql
    cd $(dirname "$0")/../code/
    curl -O https://raw.githubusercontent.com/0xsuid/cve_manager/master/cve_manager.py
    printf "Download Complete\n"
    menu
}

function load_dataset {
    echo "select the operation ************"
    echo "  1. Create Database with index - Very Slow Loading, little bit faster exec."
    echo "  2. Create Database without index - Faster Loading, little bit slower exec."

    read n
    case $n in
        1)  echo "1. Create Database with index - Very Slow Loading, little bit faster exec."
            create_db_index
            ;;
        2)  echo "2. Create Database without index - Faster Loading, little bit slower exec."
            create_db_no_index
            ;;
        *) echo "invalid option";;
    esac
}

function create_db_index {
    printf "Loading Dataset into Database - est. time(~4-5 Hours):\n"
    cd $(dirname "$0")/../../data/popular-4k/
    createdb -U postgres swhgd-popular-4k
    psql -U postgres swhgd-popular-4k < load.sql
    printf "Finished Loading Dataset into Database\n"
    menu
}

function create_db_no_index {
    printf "Loading Dataset into Database - est. time(~30-45 mins):\n"
    cp $(dirname "$0")/../../process/sql/load_no_index.sql $(dirname "$0")/../../data/popular-4k/
    cd $(dirname "$0")/../../data/popular-4k/
    createdb -U postgres swhgd-popular-4k
    psql -U postgres swhgd-popular-4k < load_no_index.sql
    printf "Finished Loading Dataset into Database\n"
    menu
}

function create_tables {
    printf "Creating Table cve_revs - est. time(~3-4 mins)\n"
    psql -U postgres swhgd-popular-4k < $(dirname "$0")/../../process/sql/create_table_cve_revs.sql
    printf "Successfully Created Table cve_revs\n"
    printf "Creating Table cve_revs_js - est. time(~20-30 mins)\n"
    psql -U postgres swhgd-popular-4k < $(dirname "$0")/../../process/sql/create_table_cve_revs_js.sql
    printf "Successfully Created Table cve_revs_js"
    printf "Creating Table cve_revs_py - est. time(~5-10 mins)\n"
    psql -U postgres swhgd-popular-4k < $(dirname "$0")/../../process/sql/create_table_cve_revs_py.sql
    printf "Successfully Created Table cve_revs_py\n"
    menu
}

function get_cve_data {
    python $(dirname "$0")/../code/cve_manager.py -d -p -csv -i $(dirname "$0")/../../data/nvd -o $(dirname "$0")/../../data/cve_parsed
}

menu